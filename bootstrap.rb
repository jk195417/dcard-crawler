# require std libs
require 'pathname'
require 'yaml'

# require all gems in Gemfile
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# setup App.root
module App
  def self.root
    Pathname(__dir__)
  end
end

# eager loading .rb
eager_loading_config = YAML::load(File.open(App.root.join('config/eager_loading.yml')))
eager_loading_paths = eager_loading_config['paths'].map { |path| App.root.join(path)  }
eager_loading_paths.each do |path|
  path.glob('**/*.rb').each do |file|
    require_relative file
  end
end
