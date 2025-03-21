class TwilioCommunication
    # id
    # created_at
    # detailes save the entire body of the request json
    include Mongoid::Document
    include Mongoid::Timestamps

    # fields
    field :twilio_id, type: String
    field :details, type: Hash

    # Indexes
    index({ twilio_id: 1 }, { unique: true })
    index({ created_at: 1 })

    # Validations
    validate :twilio_id, presence: true, uniquness: true
    validate :detailes, presence:true
    
    # Store the entier Twilio response
    def store_response(response)
        self.detailes = response.to_h
    end
end
