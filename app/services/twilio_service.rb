class TwilioService
    # simple version of sending a message
    def self.send_sms(to_number, message)
        client = Twilio::REST::Client.new(
            ENV['TWILIO_ACCOUNT_SID'],
            ENV['TWILIO_AUTH_TOKEN']
        )

        client.messages.create(
            from: ENV['TWILIO_PHONE_NUMBER'],
            to: to_number,
            body: message
        )
    end
end