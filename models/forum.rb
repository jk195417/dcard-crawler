class Forum < Sequel::Model
  one_to_many :posts

  def self.load_from_dcard(data)
    {
      dcard_id: data['id'],
      alias: data['alias'],
      name: data['name'],
      description: data['description'],
      title_placeholder: data['titlePlaceholder'],
      subcategories: data['subcategories'].to_s,
      topics: data['topics'].to_s,
      subscription_count: data['subscriptionCount'],
      is_school: data['isSchool'],
      can_post: data['canPost'],
      invisible: data['invisible'],
      fully_anonymous: data['fullyAnonymous'],
      can_use_nickname: data['canUseNickname'],
      should_categorized: data['shouldCategorized'],
      nsfw: data['nsfw'],
      created_at: DateTime.parse(data['createdAt']),
      updated_at: DateTime.parse(data['updatedAt'])
    }
  end

  def load_from_dcard(data)
    self.class.new(self.class.load_from_dcard(data))
  end

  def new_posts_from_dcard(recent: false)
    oldest_post = (recent ? nil : Post.oldest(forum_id: self.id))
    posts = JSON.parse(HTTP.get(DcardAPI.forum_posts(self.alias, before: oldest_post&.dcard_id)).to_s)
    new_posts = []
    posts.each do |post|
      next if Post.find(dcard_id: post['id'])
      new_post = Post.load_from_dcard(post)
      new_post[:forum_id] = self.id
      new_posts << new_post
    end
    new_posts
  rescue => e
    $logger.error { "Error when getting post from Forum name=#{self.alias}\n#{e.inspect}" }
  end
end
