require_relative 'initializers/initializer'

module App
  # using lib
  @@logger = MultiLogger.new(App::Config::Logger.file_path)
  @@workers = Workers.new(thread_number: 10)

  def self.logger
    @@logger
  end

  def self.workers
    @@workers
  end

  # load App Actions in to App
  extend App::Actions
end
