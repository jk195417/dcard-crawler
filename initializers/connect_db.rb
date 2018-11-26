$db = Sequel.connect(ENV['DATABASE_URL'])

# check db migrated or raise error
Sequel.extension :migration
Sequel::Migrator.check_current($db, 'db/migrations')
