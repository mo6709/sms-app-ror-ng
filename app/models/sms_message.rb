class SmsMessage
    include Mongoid::Document
    include Mongoid::Timestamps

    field :to_number, type: String
    field :message, type: String
    field :status, type: String, default: 'pending'
    field :twilio_sid, type: String
    field :error_message, type: String

    belongs_to :user

    validates :to_number, presence: true
    validates :message, presence: true

    index({ twilio_sid: 1 }, { sparse: true })
end