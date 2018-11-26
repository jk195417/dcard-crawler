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
