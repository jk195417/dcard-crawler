Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
  config.error_handlers << Proc.new do |exception, context_hash|
    App.logger.error "#{exception.inspect} #{context_hash}"
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
