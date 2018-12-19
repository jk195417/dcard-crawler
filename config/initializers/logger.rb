module App
  logger_original_formatter = Logger::Formatter.new
  @@logger_formatter = proc { |severity, datetime, progname, msg|
    case severity
    when "DEBUG"
      logger_original_formatter.call(severity.light_green, datetime, progname, msg)
    when "INFO"
      logger_original_formatter.call(severity.green, datetime, progname, msg)
    when "WARN"
      logger_original_formatter.call(severity.yellow, datetime, progname, msg)
    when "ERROR"
      logger_original_formatter.call(severity.light_red, datetime, progname, msg)
    when "FATAL"
      logger_original_formatter.call(
        severity.white.on_magenta,
        datetime,
        progname,
        msg.white.on_magenta
      )
    end
  }
  @@logger = Logger.new(STDOUT)
  @@logger.formatter = @@logger_formatter

  def self.logger
    @@logger
  end

  def self.logger_formatter
     @@logger_formatter
  end
end


# multi logger support，see config/logger.yml
extend_loggers = YAML.safe_load(File.open(App.root.join('config/logger.yml')))
if extend_loggers.present?
  extend_loggers.each do |_name, config|
    logger = Logger.new(config['path'])
    logger.formatter = App.logger_formatter
    logger.level = config['level']
    App.logger.extend(ActiveSupport::Logger.broadcast(logger))
  end
end

# logging activerecord
ActiveRecord::Base.logger = App.logger
