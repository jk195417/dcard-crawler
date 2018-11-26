class Forum < Sequel::Model
  def self.load_from_dcard(data)
    { dcard_id: data['id'],
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
      updated_at: DateTime.parse(data['updatedAt']) }
  end
  def load_from_dcard(data)
    self.class.new(self.class.load_from_dcard(data))
  end
end
