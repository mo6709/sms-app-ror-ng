module Api
    module V1
        class SmsController < ApplicationController
            skip_before_action :authenticate_user!, only: [:status]

            def create
                sms = @current_user.sms_messages.new(sms_params)

                if sms.save
                    begin
                        twilio_response = TwilioService.send_sms(sms.to_number, sms.message)
                        sms.update(status: twilio_response.status)
                        sms.update(twilio_sid: twilio_response.sid)
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

            def status
                sms = SmsMessage.find_by(twilio_sid: params[:MessageSid])
                
                if sms
                    sms.update(
                        status: params[:MessageStatus],
                        error_message: params[:ErrorMessage]
                    )

                    # send a job to queue to process asyn
                    SaveTwilioInfoJob.perform_async(params[:MessageId]);

                    head :ok
                else
                    head :not_found
                end
            end

            def show
                sms_id = params[:id]
                SmsMessage.find_by(sms_id)
            end
            
            private

            def sms_params
                params.require(:sms_params).permit(:to_number, :message)
            end
        end
    end
end