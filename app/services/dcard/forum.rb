# Class Usage :
# Dcard::Forum.to_records Dcard::Forum.get
#
# Return :
# Forums(without saved) Array.

# Instance Usage :
# forum = Dcard::Forum.new('dcard')
# forum.to_record
#
# Return :
# Forum(without saved)

class Dcard::Forum
  attr_accessor :api, :data

  def initialize(name, data: nil)
    @api = Dcard::API.forum(name)
    @data = data
  end

  def self.get
    url = Dcard::API.forums
    puts "GET #{url}"
    JSON.parse(HTTP.get(url).to_s)
  end

  def self.to_records(json_array)
    json_array.map { |forum| new(forum['alias'], data: forum).to_record }
  end

  def get
    puts "GET #{@api}"
    JSON.parse(HTTP.get(@api).to_s)
  end

  def to_record(reload: false)
    @data = get if reload
    @data ||= get
    ::Forum.new do |it|
      it.dcard_id = @data['id']
      it.alias = @data['alias']
      it.name = @data['name']
      it.description = @data['description']
      it.title_placeholder = @data['titlePlaceholder']
      it.subcategories = @data['subcategories'].to_s
      it.topics = @data['topics'].to_s
      it.subscription_count = @data['subscriptionCount']
      it.is_school = @data['isSchool']
      it.can_post = @data['canPost']
      it.invisible = @data['invisible']
      it.fully_anonymous = @data['fullyAnonymous']
      it.can_use_nickname = @data['canUseNickname']
      it.should_categorized = @data['shouldCategorized']
      it.nsfw = @data['nsfw']
      it.created_at = Time.parse(@data['createdAt'])
      it.updated_at = Time.parse(@data['updatedAt'])
    end
  end
end
