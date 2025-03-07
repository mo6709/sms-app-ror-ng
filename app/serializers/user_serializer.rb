class UserSerializer
    include JSONAPI::Serializer

    attributes :id, :email, :created_at

    attribute :token do |user|
        response = user.authentication_token if user.respond_to?(:authentication_token)
        response || request.env['warden-jwt_auth.token']
    end
end