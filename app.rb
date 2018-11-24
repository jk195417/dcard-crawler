require_relative 'initializer'

module App
  def self.run(console: false)
    response = HTTP.get(DcardAPI.forums)
    forums = JSON.parse(response.to_s)
    posts = []
    workers = Workers.new
    forums.each do |forum|
      workers.add_task do
        response = HTTP.get(DcardAPI.forum_posts(forum['alias']))
        posts << JSON.parse(response.to_s)
      rescue => e
        puts e.inspect
      end
    end
    workers.work
    binding.pry if console
  end
end
