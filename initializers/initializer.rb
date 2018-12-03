require 'pathname'
module App
  extend self
  def root
    Pathname(__dir__).join('..')
  end
end
# eager loading
require_relative App.root.join('config', 'eager_load.rb')
App::Config::EagerLoad.paths.each { |path| Dir.each_child(path) {|file| require_relative path.join(file) } }
