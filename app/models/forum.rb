class Forum < ActiveRecord::Base
  has_many :posts

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

  def new_posts_from_dcard(recent: false, popular: false)
    new_posts = []
    post_dcard_ids = posts.order(dcard_id: :asc).pluck(:dcard_id)
    oldest_post_dcard_ids = (recent ? nil : post_dcard_ids.first)
    api = DcardAPI.forum_posts(self.alias, popular: popular, before: oldest_post_dcard_ids)
    body = HTTP.get(api).to_s
    results = JSON.parse(body)
    results.each do |row|
      next if post_dcard_ids.include?(row['id'])
      new_post = Post.load_from_dcard(row)
      new_post[:forum_id] = id
      new_posts << new_post
    end
    new_posts
  rescue => e
    App.logger.error "Error when getting post from Forum name=#{self.alias} #{e.inspect}"
    new_posts
  end
end
