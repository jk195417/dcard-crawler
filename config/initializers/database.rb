config_file = File.read(App.root.join('db/config.yml'))
config = YAML.load(ERB.new(config_file).result)
ActiveRecord::Base.establish_connection(config[ENV['RAILS_ENV']])
