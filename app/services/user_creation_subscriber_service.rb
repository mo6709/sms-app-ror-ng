class UserCreationSubscriberService
    # class << self
    #     def subscrib_managers(channel)
    #         $redis.subscrib(channel) do |on|
    #             on.message do |channne, message|
    #                 puts "Recived message on #{channel}: #{message}"
    #                 # push a new job to the queu to managers_approvals witht he new user info
    #                 # TaskWorker.perform_async(data["approve_users"]) # Example Sidekiq job
    #                 yield(channel, data) if block_given?
    #             end
    #         end
    #     end

    #     def subscrib_sales_team(channel)
    #         $redis.subscrib(channel) do |on|
    #             on.message do |channel, message|
    #                 puts "Recived message on #{channel}: #{message}"
    #                 yield(channel, data) if block_given?
    #             end
    #         end
    #     end
    # end

    class << self
        def start
            RedisClient.subscrib do |data|
                process_message(data)
            rescue StandatError
                Rails.logger.error("Subscription error: #{e.message}")
            end
        end
    

        private 

        def process_message(data)
            puts "-------------------------------------------"
            puts "I am at the final place to process the data"
            puts "-------------------------------------------"
            
            Rails.logger.info "=== Received Message ==="
            Rails.logger.info data.inspect

            # case data['event_type']
            # when 'approval'
            #     puts "handle_approval()"
            # when 'sales_team'
            #     puts "handle_sales_team()"
            # end
        end

        def handle_approval(data)
        end

        def handle_sales_team(data)
        end
    end
end
