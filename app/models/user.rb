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

    has_many :sms_messages

    index({ email: 1 }, { unique: true })
    index({ jti: 1 }, { unique: true })

    before_create :ensure_jti

    private

    def ensure_jti
        self.jti ||= SecureRandom.uuid
    end
end