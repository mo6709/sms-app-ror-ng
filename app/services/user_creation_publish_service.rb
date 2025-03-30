class UserCreationPublishService
    # create group of statics methods
    class << self
        def publish_notify_managers(payload_data)
            message = {
                event_type: 'approval',
                user: {
                  id: payload_data[:user_id],
                  manager_ids: payload_data[:manager_ids]
                },
                timestamp: Time.current.to_i
            }

            # $redis.publish('approval', message)
            RedisClient.publish(message)
        end

        def publish_notify_sales_team(payload_data)
            message = {
                event_type: 'sales_team',
                user: {
                  id: payload_data[:user_id],
                  sales_teams: ['home_owners', 'mortgage']
                },
                timestamp: Time.current.to_i
            }

            # $redis.publish('sales_team', message)
            RedisClient.publish(message)
        end
    end
end