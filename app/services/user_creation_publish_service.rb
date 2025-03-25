class UserCreationPublishService
    # create group of statics methods
    class << self
        def publish_notify_managers(payload_data)
            message = {
                event: 'new_user',
                payload: payload_data,
                timestamp: Time.current
            }.to_json

            # $redis.publish('approval', message)
            RedisClient.publish(message)
        end

        def publish_notify_sales_team(payload_data)
            message = {
                event: 'new_user',
                payload: { **payload_data, sales_teams: ['home_owners', 'mortgage'] },
                timestamp: Time.current
            }

            # $redis.publish('sales_team', message)
            RedisClient.publish(message)
        end
    end
end