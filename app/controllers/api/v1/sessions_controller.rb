module Api
    module V1
        class SessionsController < Devise::SessionsController
            respond_to :json
            skip_before_action :verify_signed_out_user
            skip_before_action :verify_authenticity_token
            skip_before_action :authenticate_user!, only: [:create]

            def create
                user = User.find_by(email: sign_in_params[:email])

                if user&.valid_password?(sign_in_params[:password])
                    token = generate_jwt_token(user)
                    render json: {
                        status: { code: 200, message: 'Logged in successfully.' },
                        data: {
                            user: {
                                id: user.id.to_s,
                                email: user.email,
                                created_at: user.created_at
                            },
                            token: token
                        }
                    }, status: :ok
                else
                    render json: {
                        status: { code: 401, message: "Invalid email or password." }
                    }, status: :unauthorized
                end
            end

            def destroy
                if current_user
                    render json: {
                        status: 200,
                        message: "Logged out successfully"
                    }, status: :ok
                else
                    render json: {
                        status: 401,
                        message: "Couldn't find active session."
                    }, status: :unauthorized
                end
            end

            private

            def sign_in_params
                params.require(:user).permit(:email, :password)
            end

            def generate_jwt_token(user)
                JWT.encode(
                    { 
                        sub: user.id.to_s,
                        jti: user.jti,
                        exp: 24.hours.from_now.to_i
                    },
                    ENV['DEVISE_JWT_SECRET_KEY']
                )
            end
        end
    end
end