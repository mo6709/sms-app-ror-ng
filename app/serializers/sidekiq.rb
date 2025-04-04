Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end

Sidkiq.configure_client do |config| do
    config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end