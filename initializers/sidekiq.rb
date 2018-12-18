Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://127.0.0.1:6379/0' }
  config.error_handlers << Proc.new do |exception, context_hash|
    App.logger.error "#{exception.inspect} #{context_hash}"
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://127.0.0.1:6379/0' }
end
