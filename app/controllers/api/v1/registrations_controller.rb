module Api
    module V1
        class RegistrationsController < DeviseController
            def create
                user = User.new(sign_up_params)
                token = generate_jwt_token(user)

                if user.save
                    render json: { 
                        message: 'Signed up successfully',
                        user: user,
                        token: token
                    }, status: :created
                else
                    render json: { errors: user.errors.full_messages }, 
                           status: :unprocessable_entity
                end
            end

            private

            def sign_up_params
                params.require(:registration).permit(:email, :password)
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