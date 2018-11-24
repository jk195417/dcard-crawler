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
  desc "生成 migration 檔案"
  task :migration, [:filename] do |task, args|
    binding.pry
    filename = args.filename
    timestamp = Time.now.strftime("%Y%m%d%H%M%S%L")
    file = File.new("db/migrations/#{timestamp}_#{filename}.rb", 'a')
  end
end
