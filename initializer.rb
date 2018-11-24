# require all gems in Gemfile
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# require all initializers/*.rb
Dir.each_child('initializers') {|file| require_relative "initializers/#{file}" }

# require all services/*.rb
Dir.each_child('services') {|file| require_relative "services/#{file}" }
