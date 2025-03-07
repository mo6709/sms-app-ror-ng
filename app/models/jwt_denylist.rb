class JwtDenylist
    include Mongoid::Document
    include Mongoid::Timestamps

    field :jti, type: String
    field :exp, type: Time

    index({ jti: 1 }, { unique: true })
    index({ exp: 1 }, { expire_after_seconds: 0 })
end