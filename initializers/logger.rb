module App
  # using lib
  logger_config = YAML::load(File.open(App.root.join('config/logger.yml')))
  @@logger = MultiLogger.new(logger_config['file_path'])

  def self.logger
    @@logger
  end
end
