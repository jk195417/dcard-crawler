# Setup connection
url = Rails.application.credentials.dig(:redis, :url) || 'redis://127.0.0.1:6379/0'

Sidekiq.configure_server do |config|
  config.redis = { url: url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: url }
end
