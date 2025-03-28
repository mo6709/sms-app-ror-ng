class User 
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Devise::Models

    devise  :database_authenticatable,  :registerable,
            :recoverable, :rememberable, :validatable,
            :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist


    field :email, type: String, default: ""
    field :encrypted_password, type: String, default: ""
    field :reset_password_token, type: String
    field :reset_password_sent_at, type: Time
    field :remember_created_at, type: Time
    field :jti, type: String
    field :status, type: String, default: 'pending'
    field :approval_count, type: Integer, default: 0
    
    validates :status, inclusion: { in: ['pending', 'active', 'rejected'] }

    has_many :sms_messages
    has_many :approval_records

    index({ email: 1 }, { unique: true, background: true }) # Background indexing won't block operations
    index({ status: 1 }, { background: true })

    # OPTIMIZATION #2: Compound index for queries that filter on multiple fields
    # Order matters! Most selective field first (status), then secondary filter (approval_count)
    index({ status: 1, approval_count: 1 }, { background: true })
    index({ jti: 1 }, { unique: true })

    # OPTIMIZATION #3: TTL index for automatically expiring documents
    # Automatically remove reset password tokens after 6 hours
    index({ reset_password_sent_at: 1 }, { expire_after: 6.hours, background: true })

    # OPTIMIZATION #4: Specify fields you'll never need to query to omit from indexes
    field :login_history, type: Array, default: [], index: false

    # Callbacks
    before_create :ensure_jti
    after_create :new_user_creation

    def activate_if_approved
        if approval_count >= 2
            self.update!(status: 'active')
        end
    end

    # OPTIMIZATION #7: Bulk operations
    def self.activate_pending_users_with_approvals
        bulk_ops = []

        User.where(status: 'pending', approval_count: { '$gte' => 2 }).each do |user|
            bulk_ops << {
                update_one: {
                    filter: { _id: user.id },
                    update: { '$set' => { state: 'active' } }
                }
            }
        end

        User.collection.bulk_write(bulk_ops) if bulk_ops.any?
    end

    private

    def new_user_creation
        UserCreationPublishService.publish_notify_managers({
            user_id: self.id.to_s,
            manager_ids: [1,2]
        })
        
        UserCreationPublishService.publish_notify_sales_team({
            user_id: self.id.to_s,
        })   
    end

    def ensure_jti
        self.jti ||= SecureRandom.uuid
    end
end