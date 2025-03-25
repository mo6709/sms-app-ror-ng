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
    
    validate :status, inclusion: { in: ['pending', 'active', 'rejected'] }

    has_many :sms_messages
    has_many :approval_records

    index({ email: 1 }, { unique: true })
    index({ jti: 1 }, { unique: true })

    # Callbacks
    before_create :ensure_jti
    after_create :new_user_creation

    def activate_if_approved
        if approval_count >= 2
            self.update!(status: 'active')
        end
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