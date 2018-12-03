module App
  module Config
    module Logger
      extend self
      attr_accessor :file_path
    end
  end
end

App::Config::Logger.file_path = App.root.join('log', 'app.log')
