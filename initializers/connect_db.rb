Sequel.extension :migration
$db = Sequel.connect(ENV['DATABASE_URL'], max_connections: 10, loggers: [$logger])
$db.sql_log_level = :debug
$db.extension(:pagination)
