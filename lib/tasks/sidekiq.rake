namespace :sidekiq do
  desc '啟動 Sidekiq'
  task start: :environment do
    system('sidekiq -C ./config/sidekiq.yml')
  end
end
