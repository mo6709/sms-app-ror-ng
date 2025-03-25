class RedisClient
    class << self
        def instance
            @instance ||= Redis.new(
                url: ENV["REDIS_URL"] || "redis://localhost:6379/1"
            )
        end

        def publish(data)
            instance.publish('sms_app_channle', data.to_json)
        end

        def subscribe
            instance.subscribe('sms_app_channle') do |on|
                on.message do |_channel, message|
                    yield(JSON.parse(message))
                end
            end
        end
    end
end