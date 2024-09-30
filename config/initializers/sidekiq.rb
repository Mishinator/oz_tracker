Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
  config.logger = Logger.new(Rails.root.join('log', 'sidekiq.log'))
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
  config.logger = Logger.new(Rails.root.join('log', 'sidekiq.log'))
end
