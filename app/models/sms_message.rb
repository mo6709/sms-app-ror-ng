class SmsMessage
    include Mongoid::Document
    include Mongoid::Timestamps

    field :to_number, type: String
    field :message, type: String
    field :status, type: String, default: 'pending'
    field :twilio_sid, type: String
    field :error_message, type: String

    # Relationships
    belongs_to :user

    # INDEX STRATEGY #1: Basic single-field index
    # Good for equality matches: SmsMessage.where(status: 'sent')
    index({ status: 1 }, { background: true })

    # INDEX STRATEGY #2: Compound index
    # Perfect for queries that filter by user_id AND status
    # Order matters - most selective field first
    index({ user_id: 1, status: 1}, { background: true })

    # INDEX STRATEGY #3: Text index for full text search
    # Enables searching within message content
    index({ message: 'text' }, { background: true })

    # INDEX STRATEGY #4: Sparse index
    # Only includes documents that have the field, efficient for optional fields
    index({ twilio_sid: 1 }, { sparse: true, background: true })

    # INDEX STRATEGY #5: TTL index for automatic document expiration
    index({ created_at: 1 }, { experation: 90.days, background: true })

    # INDEX STRATEGY #6: Unique index for fields that must be unique
    # Prevents duplicate tracking of the same external SMS
    index({ twilio_sid: 1 }, { unique: true, sparse: true, background: true })

    # INDEX STRATEGY #7: Partial index (MongoDB 3.2+)
    # More efficient than a normal index when you frequently query a subset
    # This index only includes documents with status 'failed'
    index(
        { created_at: 1 }, 
        {
            background: true,
            partial_filter_expression { status: 'failed' }
        }
    )

    validate :to_number, presence: true
    validate :message, presence: true

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