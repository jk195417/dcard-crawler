module App
  module Config
    module EagerLoad
      extend self
      @paths = []
      attr_accessor :paths
    end
  end
end

App::Config::EagerLoad.paths << App.root.join('config')
App::Config::EagerLoad.paths << App.root.join('lib')
App::Config::EagerLoad.paths << App.root.join('initializers')
App::Config::EagerLoad.paths << App.root.join('app', 'models')
App::Config::EagerLoad.paths << App.root.join('app', 'actions')
