require_relative 'initializer'

module App
  def self.run()
    binding.pry
  end
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

  def self.update_forums(console: false)
    response = HTTP.get(DcardAPI.forums)
    forums = JSON.parse(response.to_s)
    forums.each do |forum_hash|
      forum = Forum.find(name: forum_hash['name'])
      if forum
        forum.update(Forum.load_from_dcard(forum_hash))
      else forum
        forum = Forum.new.load_from_dcard(forum_hash)
        forum.save
      end
    end
    binding.pry if console
  end
end
