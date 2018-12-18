db_config = YAML::load(File.open(App.root.join('db/config.yml')))
ActiveRecord::Base.establish_connection(db_config[ENV['RAILS_ENV']])
ActiveRecord::Base.logger = Logger.new(STDOUT)
