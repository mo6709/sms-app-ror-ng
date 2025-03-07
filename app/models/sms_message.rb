class SmsMessage
    include Mongoid::Document
    include Mongoid::Timestamps

    field :to_number, type: String
    field :message, type: String
    field :status, type: String

    belongs_to :user

    validates :to_number, :message, presence: true
end