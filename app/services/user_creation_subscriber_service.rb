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
            puts "+++++++++++++++++++++++++++++++++"
            puts "Starting Redis subscription..."
            puts "+++++++++++++++++++++++++++++++++"

            Rails.logger.info "Starting Redis subscription service..."
            
            begin
                RedisClient.subscribe do |data|
                    process_message(data)
                end
            rescue StandardError => e
                puts "Subscription error: #{e.message}"
                Rails.logger.error("Subscription error: #{e.message}")
                Rails.logger.error(e.backtrace.join("\n"))
            end
        end
    

        private 

        def process_message(data)
            puts "-------------------------------------------"
            puts "I am at the final place to process the data"
            puts "-------------------------------------------"
            puts "DATA RECEIVED: #{data.inspect}"
            
            # Log to both console and Rails logger
            Rails.logger.info "=== Received Message ==="
            Rails.logger.info data.inspect
            
            # Write to log file directly to ensure it gets captured
            File.open(Rails.root.join('log', 'redis_messages.log'), 'a') do |f|
              f.puts "#{Time.now}: Received message: #{data.inspect}"
            end
            
            # case data['event_type']
            # when 'approval'
            #     puts "Processing approval event"
            #     handle_approval(data)
            # when 'sales_team'
            #     puts "Processing sales team event"
            #     handle_sales_team(data)
            # else
            #     puts "Unknown event type: #{data['event_type']}"
            # end
        end

        def handle_approval(data)
            puts "Handling approval for user: #{data['user']['name']}"
            # Your approval logic here
        end

        def handle_sales_team(data)
            puts "Handling sales team notification for user: #{data['user']['name']}"
            # Your sales team logic here
        end
    end
end
