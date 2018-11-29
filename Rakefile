require_relative 'app'

namespace :g do
  desc '生成 migration'
  task :migration do
    title = ARGV[1] || 'no_name'
    version = 0
    version = $db[:schema_info].first[:version] if $db.tables.include?(:schema_info)
    new_version = version + 1
    folder = 'db/migrations'
    filename = "#{format('%03d', new_version)}_#{title}.rb"
    File.open("#{folder}/#{filename}", 'w') do |f|
      f << "Sequel.migration do\n"
      f << "\tchange do\n"
      f << "\t\t# migration code here...\n"
      f << "\tend\n"
      f << 'end'
    end
    $logger.debug { "migration file #{filename} created at #{folder}" }
    abort # needed stop other tasks
  end
end

namespace :db do
  desc 'Prints current schema version'
  task :version do
    version = 0
    version = $db[:schema_info].first[:version] if $db.tables.include?(:schema_info)
    $logger.debug { "Schema Version: #{version}" }
  end

  desc 'Dump Database Schema To db/schema.rb'
  task :dump_schema do
    $logger.debug { 'Dump Database Schema To db/schema.rb' }
    system("sequel -d #{ENV['DATABASE_URL']} > db/schema.rb")
  end

  desc 'Perform migration up to latest migration available'
  task :migrate do
    Sequel::Migrator.run($db, 'db/migrations')
    Rake::Task['db:version'].execute
    Rake::Task['db:dump_schema'].execute
  end

  desc 'Perform rollback to specified target or rollback last version as default'
  task :rollback do
    version = ($db.tables.include?(:schema_info) ? $db[:schema_info].first[:version] : 0)
    target = ARGV[1] || version - 1
    if version.to_i == 0
      $logger.debug { 'no migration can be rollback' }
    else
      Sequel::Migrator.run($db, 'db/migrations', target: target.to_i)
      Rake::Task['db:version'].execute
      Rake::Task['db:dump_schema'].execute
    end
    abort # needed stop other tasks
  end

  desc 'check db migrated or raise error'
  task :check_migrated do
    Sequel::Migrator.check_current($db, 'db/migrations')
  end
end

desc '進入互動模式'
task :run do
  App.run
end

namespace :run do
  desc '獲取並更新所有的 Forums'
  task :update_forums do
    c = !ARGV[1].nil?
    App.update_forums(console: c)
    abort # needed stop other tasks
  end

  desc '獲取 100 則 Post'
  task :get_posts do
    c = !ARGV[1].nil?
    App.get_posts(console: c)
    abort # needed stop other tasks
  end

  desc '獲取每個 Forum 各 100 則 Post'
  task :get_forums_posts do
    c = !ARGV[1].nil?
    App.get_forums_posts(console: c)
    abort # needed stop other tasks
  end
end

task :run => 'db:check_migrated'
task 'run:update_forums' => 'db:check_migrated'
task 'run:get_posts' => 'db:check_migrated'
task 'run:get_forums_posts' => 'db:check_migrated'
