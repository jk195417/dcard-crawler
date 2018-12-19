# require std libs
require 'pathname'
require 'yaml'
require 'logger'

# setup App
require_relative 'app'

# load environment variables from config/.env
Dotenv.load(App.root.join('config/.env'))

# loading all .rb file in order from these folders，see config/loading_order.yml
loading_order = YAML::load(File.open(App.root.join('config/loading_order.yml')))
loading_paths = loading_order['folders'].map { |folder| App.root.join(folder)  }
loading_paths.each do |path|
  path.glob('**/*.rb').each do |file|
    require_relative file
  end
end
