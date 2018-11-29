# require environment variables at /config/env.rb
require_relative 'config/env'

# require all gems in Gemfile
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# require all initializers/*.rb
require_relative 'initializers/multi_logger'
Dir.each_child('initializers') {|file| require_relative "initializers/#{file}" }

# require all models/*.rb
Dir.each_child('models') {|file| require_relative "models/#{file}" }

# require all services/*.rb
Dir.each_child('services') {|file| require_relative "services/#{file}" }
