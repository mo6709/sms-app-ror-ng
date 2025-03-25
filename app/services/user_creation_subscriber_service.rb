class UserCreationSubscriberService
    # class << self
    #     def subscrib_managers(channel)
    #         $redis.subscrib(channel) do |on|
    #             on.message do |channne, message|
    #                 puts "Recived message on #{channel}: #{message}"
    #                 # push a new job to the queu to managers_approvals witht he new user info
    #                 # TaskWorker.perform_async(data["approve_users"]) # Example Sidekiq job
    #                 yield(channel, data) if block_given?
    #             end
    #         end
    #     end

    #     def subscrib_sales_team(channel)
    #         $redis.subscrib(channel) do |on|
    #             on.message do |channel, message|
    #                 puts "Recived message on #{channel}: #{message}"
    #                 yield(channel, data) if block_given?
    #             end
    #         end
    #     end
    # end

    class << self
        def start
            puts "Starting Redis subscription..."
            RedisClient.subscribe do |data|
                process_message(data)
            rescue StandardError => e
                Rails.logger.error("Subscription error: #{e.message}")
            end
        end
    

        private 

        def process_message(data)
            puts "-------------------------------------------"
            puts "I am at the final place to process the data"
            puts "-------------------------------------------"
            
            Rails.logger.info "=== Received Message ==="
            Rails.logger.info data.inspect
            
            # puts data.inspect
            
            # case data['event_type']
            # when 'approval'
            #     puts "Processing approval event"
            #     handle_approval(data)
            # when 'sales_team'
            #     puts "Processing sales team event"
            #     handle_sales_team(data)
            # else
            #     puts "Unknown event type: #{data['event_type']}"
            # end
        end

        def handle_approval(data)
            puts "Handling approval for user: #{data['user']['name']}"
            # Your approval logic here
        end

        def handle_sales_team(data)
            puts "Handling sales team notification for user: #{data['user']['name']}"
            # Your sales team logic here
        end
    end
end
