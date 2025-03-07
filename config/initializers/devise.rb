# frozen_string_literal: true

Devise.setup do |config|
    config.jwt do |jwt|
        jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
        jwt.dispatch_requests = [
            ['POST', %r{^/api/v1/auth/login$}]
        ]
        jwt.revocation_requests = [
            ['DELETE', %r{^/api/v1/auth/logout$}]
        ]
        jwt.expiration_time = 24.hours.to_i
    end

    config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
    config.case_insensitive_keys = [:email]
    config.strip_whitespace_keys = [:email]
    config.skip_session_storage = [:http_auth]
    config.stretches = Rails.env.test? ? 1 : 12
    config.reconfirmable = true
    config.expire_all_remember_me_on_sign_out = true
    config.password_length = 6..128
    config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
    config.reset_password_within = 6.hours
    config.sign_out_via = :delete
    config.navigational_formats = []
end