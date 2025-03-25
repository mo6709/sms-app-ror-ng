# Start the Redis subscription in a separate thread
# Only start in server mode (not during rake tasks, console, etc)
if defined?(Rails::Server)
  Thread.new do
    begin
      Rails.logger.info "Starting Redis subscription thread"
      # Give the application time to fully initialize
      sleep 5
      UserCreationSubscriberService.start
    rescue => e
      Rails.logger.error "Redis subscription thread error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end 