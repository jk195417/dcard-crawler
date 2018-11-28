require_relative 'app'
Sequel.extension :migration

namespace :g do
  desc '生成 migration 檔案'
  task :migration, :title do |_task, args|
    args.with_defaults(title: 'no_name')
    version = 0
    version = $db[:schema_info].first[:version] if $db.tables.include?(:schema_info)
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
  desc 'Prints current schema version'
  task :version do
    version = 0
    version = $db[:schema_info].first[:version] if $db.tables.include?(:schema_info)
    puts "Schema Version: #{version}"
  end

  desc 'Dump Database Schema To db/schema.rb'
  task :dump_schema do
    puts('Dump Database Schema To db/schema.rb')
    system("sequel -d #{ENV['DATABASE_URL']} > db/schema.rb")
  end

  desc 'Perform migration up to latest migration available'
  task :migrate do
    Sequel::Migrator.run($db, 'db/migrations')
    Rake::Task['db:version'].execute
    Rake::Task['db:dump_schema'].execute
  end

  desc 'Perform rollback to specified target or rollback last version as default'
  task :rollback, :target do |_task, args|
    args.with_defaults(target: 0)
    version = ($db.tables.include?(:schema_info) ? $db[:schema_info].first[:version] : 0)
    if version.to_i == 0
      puts('no migration can be rollback')
    else
      target = version - 1 if args[:target].to_i == 0
      Sequel::Migrator.run($db, 'db/migrations', target: target)
      Rake::Task['db:version'].execute
      Rake::Task['db:dump_schema'].execute
    end
  end
end

# check db migrated or raise error
Sequel::Migrator.check_current($db, 'db/migrations')

desc '進入互動模式'
task :run do
  puts '進入互動模式'
  App.run
end

namespace :run do
  desc '獲取並更新所有的 Forums，帶入參數 c 進入命令列模式'
  task :update_forums, :console do |_task, args|
    puts '獲取並更新所有的 Forums'
    if args.console == 'c'
      puts '進入命令列模式'
      App.update_forums(console: true)
    else
      App.update_forums
    end
  end

  desc '獲取 100 則 Post，帶入參數 c 進入命令列模式'
  task :get_posts, :console do |_task, args|
    puts '獲取最新的 100 則 Post'
    if args.console == 'c'
      puts '進入命令列模式'
      App.get_posts(console: true)
    else
      App.get_posts
    end
  end

  desc '獲取每個 Forum 各 100 則 Post，帶入參數 c 進入命令列模式'
  task :get_forums_posts, :console do |_task, args|
    puts '獲取每個 Forum 各 100 則 Post'
    if args.console == 'c'
      puts '進入命令列模式'
      App.get_forums_posts(console: true)
    else
      App.get_forums_posts
    end
  end
end
