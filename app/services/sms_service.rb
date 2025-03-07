class SmsService
    # more complex version of sending message
    def initialize(usr)
        @user = user
        @client = TwilioService.client
    end

    def send_message(to_number, message)
        validate_phone_number!(to_number)

        sms = @user.sms_messages.new(
            to_number: to_number,
            message: message
        )

        if sms.save
            deliver_sms(sms)
        else
            raise ServiceError(sms.errors.full_messages.join(', '))
        end
    end

    private

    def validate_phone_number!(number)
        unless PhoneNumberValidator.valid(number)
            rails ServiceError.new('Invalid phone number format')
        end
    end

    def deliver_sms(sms)
        response = @client.message.create(
            from: ENV['TWILIO_PHONE_NUMBER'],
            to: sms.to_number,
            body: sms.message
        )

        sms.update(status: 'sent', external_id: response.sid)
        sms
        rescue Twilio::REST::RestError => e
            sms.update(status: 'faild', error_message: e.message)
            raise ServiceError.new(e.message)
        end
    end


end