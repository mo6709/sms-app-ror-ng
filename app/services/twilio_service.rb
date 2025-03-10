class TwilioService
    # simple version of sending a message
    def self.send_sms(to_number, message)
        client = Twilio::REST::Client.new(
            ENV['TWILIO_ACCOUNT_SID'],
            ENV['TWILIO_AUTH_TOKEN']
        )

        # "#{ENV['BASE_URL']}/api/v1/sms/status"
        # "https://963e-69-121-44-94.ngrok-free.app/api/v1/sms/status"
        client.messages.create(
            from: ENV['TWILIO_PHONE_NUMBER'],
            to: to_number,
            body: message,
            status_callback: "https://963e-69-121-44-94.ngrok-free.app/api/v1/sms/status"
        )
    end
end