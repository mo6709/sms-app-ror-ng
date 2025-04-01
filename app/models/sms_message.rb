class SmsMessage
    include Mongoid::Document
    include Mongoid::Timestamps

    field :to_number, type: String
    field :message, type: String
    field :status, type: String, default: 'pending'
    field :twilio_sid, type: String
    field :error_message, type: String
    field :deleted, type: Boolean, default: false
    field :deleted_at, type: Time

    # Relationships
    belongs_to :user

    # Good for equality matches: SmsMessage.where(status: 'sent')
    index({ status: 1 }, { background: true })


    # Perfect for queries that filter by user_id AND status
    index({ user_id: 1, status: 1}, { background: true })

    # Enables searching within message content
    index({ message: 'text' }, { background: true })

    # Only includes documents that have the field, efficient for optional fields
    index({ twilio_sid: 1 }, { sparse: true, background: true })


    index({ created_at: 1 }, { expire_after_seconds: 90.days.in_milliseconds, background: true })

    # Prevents duplicate tracking of the same external SMS
    index({ twilio_sid: 1 }, { unique: true, sparse: true, background: true })

    # This index only includes documents with status 'failed'
    index(
        { created_at: 1 }, 
        {
            background: true,
            partial_filter_expression: { status: 'failed' }
        }
    )
    
    # Scoping for bette and fast results
    scope :active, -> { where(deleted: false) }

    validates :to_number, presence: true
    validates :message, presence: true
    # validates :status, inclusion: { in: ['queued', 'sending', 'sent', 'delivered', 'undelivered', 'failed', 'received'] }

    # This query uses the compound index
    def self.recent_by_user(user_id, limit = 10)
        where(user_id: user_id)
            .order(crearted_at: :desc)
            limit(limit)
    end

    # This query uses the text index
    def self.search_messages(query)
        full_text_search(query)
    end

    # This query benefits from the partial index
    def self.recent_failures(days = 7)
        where(
            status: 'failed',
            created_at: { 'gte' => Time.now - days.days }
        ).order(crearted_at: :desc)
    end
end