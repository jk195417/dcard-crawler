require 'logger'

class MultiLogger
  def initialize(file_path)
    @stdout_logger = Logger.new(STDOUT)
    @file_logger = Logger.new(file_path)
    @file_logger.level = :info
  end

  def debug(message)
    @stdout_logger.debug message
    @file_logger.debug message
  end

  def info(message)
    @stdout_logger.info message
    @file_logger.info message
  end

  def warn(message)
    @stdout_logger.warn message
    @file_logger.warn message
  end

  def error(message)
    @stdout_logger.error message
    @file_logger.error message
  end

  def fatal(message)
    @stdout_logger.fatal message
    @file_logger.fatal message
  end

  def close
    @stdout_logger.close
    @file_logger.close
  end
end
