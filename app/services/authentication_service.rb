class AuthenticationService
    def self.authenticate(to_number, message)
        api_kei = request.headers['Authorization'][&.split](' ')&.last
        User.find_by(api_kei: api_kei)
    end
end