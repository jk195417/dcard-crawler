class Forum < ApplicationRecord
  include Dcard::LoadData

  has_many :posts, dependent: :destroy

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
      created_at: Time.parse(data['createdAt']),
      updated_at: Time.parse(data['updatedAt'])
    }
  end

  def dcard_url
    'https://www.dcard.tw/f/' + self.alias
  end

  def pull_from_dcard
    load_from_dcard(JSON.parse(HTTP.get(Dcard::Api.forum(self.alias)).to_s))
  end

  def new_posts_from_dcard(recent: false, popular: false)
    new_posts = []
    post_dcard_ids = posts.order(dcard_id: :asc).pluck(:dcard_id)
    api = if recent
            Dcard::Api.forum_posts(self.alias, popular: popular, after: post_dcard_ids.last)
          else
            Dcard::Api.forum_posts(self.alias, popular: popular, before: post_dcard_ids.first)
          end
    body = HTTP.get(api).to_s
    results = JSON.parse(body)
    results.each do |row|
      next if post_dcard_ids.include?(row['id'])

      new_post = Post.load_from_dcard(row)
      new_post[:forum_id] = id
      new_posts << new_post
    end
    new_posts
  rescue StandardError => e
    Rails.logger.error "Error when getting forum #{id} posts from #{api} #{e.inspect}"
    new_posts
  end
end
