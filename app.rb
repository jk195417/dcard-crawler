require_relative 'initializer'

module App
  def self.run()
    binding.pry
  end

  def self.update_forums(console: false)
    new_forums = []
    response = HTTP.get(DcardAPI.forums)
    forums = JSON.parse(response.to_s)
    forums.each do |f|
      f_values = Forum.load_from_dcard(f)
      forum = Forum.find(name: f['name'])
      forum.nil? ? (new_forums << f_values) : forum.update(f_values)
    end
    $db[:forum].multi_insert(new_forums)
    binding.pry if console
  end

  def self.get_forums_posts(console: false, recent: false)
    workers = Workers.new(thread_number: 4)
    forums = Forum.all
    new_posts = []
    forums.each do |forum|
      workers.add_task do
        new_posts += forum.new_posts_from_dcard(recent: recent).to_a
      end
    end
    workers.work
    $db[:posts].multi_insert(new_posts)
    $logger.info { "Get #{new_posts.size} new posts and inserted into database" }
    binding.pry if console
  end

  def self.get_posts(console: false)
    workers = Workers.new(thread_number: 4)
    new_posts = []
    oldest_post = Post.oldest
    response = HTTP.get(DcardAPI.posts(popular: true, before: oldest_post&.dcard_id))
    posts = JSON.parse(response.to_s)
    posts.each do |post|
      workers.add_task do
        unless Post.find(dcard_id: post['id'])
          forum = Forum.find(name: post['forumName'])
          new_post = Post.load_from_dcard(post)
          new_post[:forum_id] = forum&.id
          new_posts << new_post
        end
      rescue => e
        $logger.error { e.inspect }
      end
    end
    workers.work
    $db[:posts].multi_insert(new_posts)
    binding.pry if console
  end
end
