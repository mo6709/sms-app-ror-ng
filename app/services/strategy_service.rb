class StrategyService 
    def self.get_notification_strategy(type)
        case type
        when :sms
            #return lamda for sms notification
            ->(user, message) {
                return false unless user.phone_number

                #logic
                sms_service = SmsService.new(user)
                result = sms_service.send_message(user.phone_number, message)

                { success: result.present?, method: :sms }
            }
        when :email
            # return lambda for email
            ->(user, message) {
                return false unless user.email

                UserMailer.notification(user.email, message).deliver_now

                { success: true, method: :email }
            }
        when :push
            # return lambda for push notification
            ->(user, email) {
                return false unless user.device_token

                PushNotificationService.send(
                    token: user.device_token,
                    message: message,
                    data: { type: 'notification' }
                )
                { success: true, method: :push }
            }
        when :multi
            # return lambda that tries multiple strategies in order
            ->(user, message) {
                # try first sms
                sms_strategy = get_notification_strategy(:sms)
                sms_result = sms_strategy.call(user, message)
                return sms_result if sms_result[:success]

                #second email
                email_strategy = get_notification_strategy(:email)
                email_result = email_strategy.call(user, message)
                return email_result if email_result[:success]

                # third push
                push_strategy = get_notification_strategy(:push)
                push_result = push_strategy.call(user, message)
                return push_result if push_result[:success]

                # all failed
                { success: false, method: :none }
            }
        else
            # default strategy will return failure
            ->(user, message) {
                { success: false, method: :unknown }
            }
        end
    end

    # Example Using get_notification_strategy
    def self.notify_user(user, message, preferred_method = nil)
        method = preferred_method || user.preferred_notification_method || :multi
        
        strategy = get_notification_strategy(method)

        result = strategy.call(user, message)

        NotificationLog.create(
            user_id: user.id,
            message: message,
            method_attemped: result[:method],
            success: result[:success]
        )

        result
    end
end