module Api
    module V1
        class SmsController < ApplicationController
            def create
                sms = @current_user.sms_messages.new(sms_params)

                if sms.save
                    begin
                        twilio_response = TwilioService.send_sms(sms.to_number, sms.message)
                        sms.update(status: 'sent')
                        render json: sms, status: :created
                    rescue => e
                        sms.update(status: 'failed')
                        render json: { error: e.message }, status: :unprocessable_entity
                    end
                else
                    render json: { errors: sms.errors.full_messages }, status: :unprocessable_entity
                end
            end

            def index
                sms_messages = @current_user.sms_messages
                render json: sms_messages
            end

            private

            def sms_params
                params.require(:sms_params).permit(:to_number, :message)
            end
        end
    end
end