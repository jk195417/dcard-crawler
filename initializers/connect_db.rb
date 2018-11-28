$db = Sequel.connect(ENV['DATABASE_URL'], max_connections: 5)

# check db migrated or raise error
Sequel.extension :migration
Sequel::Migrator.check_current($db, 'db/migrations')
