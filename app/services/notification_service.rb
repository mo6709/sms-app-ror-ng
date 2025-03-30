class NotificationService
    class << self
        def notify_manager(user_id:)
            broadcast_to_managers("please approve user #{user_id}")
        end

        def notify_sales_team(user_id:)
            broadcast_to_sales_team("new user #{user_id}")
        end

        private

        def broadcast_to_managers(message)
            ActionCable.server.broadcast(message)
        end

        def broadcast_to_sales_team(message)
            ActionCable.server.broadcast(message)
        end
    end
end