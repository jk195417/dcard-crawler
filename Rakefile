require_relative 'app'

desc '執行主程式'
task :run do
  puts '開始執行主程式'
  App.run
end

namespace :run do
  desc '命令列模式'
  task :c do
    puts '進入命令列模式'
    App.run(console: true)
  end
end

namespace :g do
  desc '生成 migration 檔案'
  task :migration, :title do |_task, args|
    args.with_defaults(title: 'no_name')
    version = 0
    version = DB[:schema_info].first[:version] if DB.tables.include?(:schema_info)
    new_version = version + 1
    folder = 'db/migrations'
    filename = "#{format('%03d', new_version)}_#{args.title}.rb"
    File.open("#{folder}/#{filename}", 'w') do |f|
      f << "Sequel.migration do\n"
      f << "\tchange do\n"
      f << "\t\t# migration code here...\n"
      f << "\tend\n"
      f << 'end'
    end
    puts "migration file #{filename} created at #{folder}"
  end
end

namespace :db do
  require_relative 'config/env'
  require 'sequel'
  Sequel.extension :migration
  DB = Sequel.connect(ENV['DATABASE_URL'])

  desc 'Prints current schema version'
  task :version do
    version = 0
    version = DB[:schema_info].first[:version] if DB.tables.include?(:schema_info)
    puts "Schema Version: #{version}"
  end

  desc 'Dump Database Schema To db/schema.rb'
  task :dump_schema do
    puts('Dump Database Schema To db/schema.rb')
    system("sequel -d #{ENV['DATABASE_URL']} > db/schema.rb")
  end

  desc 'Perform migration up to latest migration available'
  task :migrate do
    Sequel::Migrator.run(DB, 'db/migrations')
    Rake::Task['db:version'].execute
    Rake::Task['db:dump_schema'].execute
  end

  desc 'Perform rollback to specified target or rollback last version as default'
  task :rollback, :target do |_task, args|
    args.with_defaults(target: 0)
    version = (DB.tables.include?(:schema_info) ? DB[:schema_info].first[:version] : 0)
    if version.to_i == 0
      puts('no migration can be rollback')
    else
      target = version - 1 if args[:target].to_i == 0
      Sequel::Migrator.run(DB, 'db/migrations', target: target)
      Rake::Task['db:version'].execute
      Rake::Task['db:dump_schema'].execute
    end
  end
end
