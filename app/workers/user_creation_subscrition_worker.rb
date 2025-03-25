class UserCreationSubscriptionWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform
        UserCreationSubscriberService.start
    rescue Redis::BaseConnectionError => e
        Rails.logger.error("Redis connection error: #{e.message }")
        retry_with_backoff
    end

    private

    def retry_with_backoff
        sleep(5)
        UserCreationSubscriptionWorker.perform_async
    end
end
