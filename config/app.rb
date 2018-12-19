# require all gems in Gemfile
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

module App
  def self.root
    Pathname(__dir__).join('..')
  end
end
