$db = Sequel.connect(ENV['DATABASE_URL'], max_connections: 5, loggers: [$logger])
Sequel.extension :migration, :pagination
