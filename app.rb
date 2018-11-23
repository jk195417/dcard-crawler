require_relative 'setup'

module App
  def self.run(console: false)
    self.do_something
    binding.pry if console
  end

  def self.do_something
    puts 'do something'
  end
end
