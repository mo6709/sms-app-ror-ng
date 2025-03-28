#     1. Modules as Mixins: The SimpleORM::Document module is designed to be "mixed in" to classes using include.
#     2. Metaprogramming:
#         define_method dynamically creates methods
#         instance_variable_get/set manipulates object state
#         send dynamically calls methods
#         class_eval executes code in a class context
#     3. Module Hooks:
#         self.included is called when a module is included in a class
#         extend adds methods from another module as class methods
#     4. Method-Missing Pattern:
#         respond_to? checks if a method exists before calling it
#     5. Memoization:
#         @collection ||= ... assigns a value only if the variable is nil
#     This SimpleORM provides a lightweight version of what Mongoid does, helping you understand how ORMs map Ruby objects to database documents.
module SimpleORM
    module Document
        def  self.included(base)
            base.extend(ClassMethod)

            base.class_eval do
                def initialize(attributes={})
                    attributes.each do |key, val|
                        send("#{key}=", value) if respond_to?("#{key}=")
                    end
                end

                def save
                    self.class.collection.insert_one(attributes)
                end

                def update(updates)
                    self.class.collection.update_one(
                        { _id: @_id },
                        { '$set' => updates }
                    )

                    updates.each do |key,value|
                        send("#{key}=", value) if respond_to?("#{key}=")
                    end
                end

                def delete
                    self.class.collection.delete_one(_id: @_id)
                end

                def attributes
                    instance_variables.each_with_object({}) do |var, hash|
                        key = var.to_s.delete('@')
                        hash[key] = instance_variable_get(var)
                    end
                end
            end
        end
    end

    module ClasssMethods
        def field(name, options={})
            define_method(name) do
                instance_variables_get("@#{name}")
            end

            define_method("#{name}") do |value|
                instance_variable_set("@#{name}", value)
            end

            @fields ||=[]
            @fields << name
        end

        def collection
            collection_name = name.downcase.pluralize
            @collection ||= Mongo::Client.new([ENV['MONGODB_URL']])["#{collection_name}"]
        end

        def find(id)
            doc = collection.find(_id: BSON::ObjectId.from_string(id)).first
            return nil unless doc

            instance = new

            doc.each do |key, value|
                instance.instance_variable_set("@#{key}", value)
            end

            instance
        end

        def where(criteria)
            collection.find(criteria).map do |doc|
                instance = new

                doc.each do |key, value|
                    instance.instance_variable_set("@#{key}", value)
                end
                
                instance
            end
        end

        def index(fields, options={})
            collection.indexes.create_one(fields, options)
        end
    end
end

# Example usage showing how a model would use this SimpleORM
class Message
    # Including SimpleORM::Document gives this class all the ORM functionality
    include SimpleORM::Document
    
    # Define database fields - each creates getter and setter methods
    field :user_id     # Creates user_id and user_id= methods
    field :content     # Creates content and content= methods
    field :sent_at     # Creates sent_at and sent_at= methods
    field :status, default: 'pending'  # The default option isn't implemented in our SimpleORM
    
    # Create indexes for common query patterns
    index({ user_id: 1 })  # Index user_id in ascending order
    index({ sent_at: 1 })  # Index sent_at in ascending order
    
    # Custom domain methods that use the ORM's update method
    def mark_as_sent
      update(status: 'sent', sent_at: Time.now)
    end
    
    # Simple helper method
    def sent?
      status == 'sent'
    end
end