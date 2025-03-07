module Api
    module V1
        class SessionsController < Devise::SessionsController
            # respond_to :json
            # skip_before_action :verify_signed_out_user
            # skip_before_action :verify_authenticity_token

            # private

            # def respond_with(resource, _opts = {})
            #     if resource.persisted?
            #         token = generate_jwt_token(resource)
            #         render json: {
            #             status: { code: 200, message: 'Logged in successfully.' },
            #             data: {
            #                 user: {
            #                     id: resource.id.to_s,
            #                     email: resource.email,
            #                     created_at: resource.created_at
            #                 },
            #                 token: token
            #             }
            #         }, status: :ok
            #     else
            #         render json: {
            #             status: { code: 401, message: "Invalid email or password." }
            #         }, status: :unauthorized
            #     end
            # end

            # def respond_to_on_destroy
            #     if current_user
            #         render json: {
            #             status: 200,
            #             message: "Logged out successfully"
            #         }, status: :ok
            #     else
            #         render json: {
            #             status: 401,
            #             message: "Couldn't find active session."
            #         }, status: :unauthorized
            #     end
            # end

            # protected

            # def generate_jwt_token(user)
            #     JWT.encode(
            #         { 
            #             sub: user.id.to_s,
            #             jti: user.jti,
            #             exp: 24.hours.from_now.to_i
            #         },
            #         ENV['DEVISE_JWT_SECRET_KEY']
            #     )
            # end
        end
    end
end