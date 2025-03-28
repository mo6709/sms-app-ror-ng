class ProcessingService
    def self.process_with_hooks(data, options ={})
        before_action = options[:before] || -> { puts "Starting processing..." }
        after_action = options[:after] || -> { puts "Processing complete" }
        error_action = options[:on_error] || -> { puts "Error: #{e.message}" }

        before_action.call
        
        begin 
            result = yield(data) if block_given?

            after_action.call(result)

            result
        rescue => e
            error_action.call(e)
            raise e
        end
    end

    def self.process_sms_batch(messages)
        before_hook = -> {
            put "Starting batch processing at #{TIme.now}"
        }

        after_hook = ->(result) {
            puts "Processed #{result.size} messages at #{Time.now}"
        }

        error_hook = ->(e) {
            puts "Filed to process sms batch: #{e.message}"
        }

        process_with_hooks(
            messages, 
            before: before_hook,
            after: after_hook,
            on_error: error_hook
        ) do |messages|
            results = []
            messages.each do |msg|
                puts "Sending message to #{msg[:to]}"
                results << { id: msg[:id], status: 'sent' }
            end

            results
        end
    end
end

