class RedisSubscriptionWorker
  include Sidekiq::Worker
  sidekiq_options retry: false  # Don't retry as subscriptions are stateful

  def perform
    UserCreationSubscriberService.start
  # This will block and will not return until process is terminated
  rescue => e
    Rails.logger.error("Redis subscription worker error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end 