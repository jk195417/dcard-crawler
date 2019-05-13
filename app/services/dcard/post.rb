# Class Usage :
# Dcard::Post.to_records Dcard::Post.get(forum: 'dcard')
# Dcard::Post.to_records Dcard::Post.search(query: 'query')
#
# Return :
# Posts(without saved) Array.

# Instance Usage :
# post = Dcard::Post.new(dcard_id).to_record
#
# Return :
# Post(without saved)

class Dcard::Post
  attr_accessor :api, :data

  def initialize(dcard_id, data: nil)
    @api = Dcard::API.post(dcard_id)
    @data = data
  end

  def self.get(**options)
    url = Dcard::API.posts(options)
    puts "GET #{url}"
    JSON.parse(HTTP.get(url).to_s)
  end

  def self.search(**options)
    url = Dcard::API.search_posts(options)
    puts "GET #{url}"
    JSON.parse(HTTP.get(url).to_s)
  end

  def self.to_records(json_array)
    json_array.map { |post| new(post['id'], data: post).to_record }
  end

  def get
    puts "GET #{@api}"
    JSON.parse(HTTP.get(@api).to_s)
  end

  def to_record(reload: false)
    @data = get if reload
    @data ||= get
    ::Post.new do |it|
      it.dcard_id = @data['id']
      it.reply_id = @data['replyId']
      it.comment_count = @data['commentCount']
      it.like_count = @data['likeCount']
      it.title = @data['title']
      it.content = @data['content']
      it.excerpt = @data['excerpt']
      it.tags = @data['tags'].to_s
      it.topics = @data['topics'].to_s
      it.forum_name = @data['forumName']
      it.forum_alias = @data['forumAlias']
      it.gender = @data['gender']
      it.school = @data['school']
      it.department = @data['department']
      it.reply_title = @data['replyTitle']
      it.reactions = @data['reactions'].to_s
      it.custom_style = @data['customStyle'].to_s
      it.media = @data['media'].to_s
      it.anonymous_school = @data['anonymousSchool']
      it.anonymous_department = @data['anonymousDepartment']
      it.pinned = @data['pinned']
      it.with_nickname = @data['withNickname']
      it.hidden = @data['hidden']
      it.with_images = @data['withImages']
      it.with_videos = @data['withVideos']
      it.created_at = Time.parse(@data['createdAt'])
      it.updated_at = Time.parse(@data['updatedAt'])
    end
  end

  # def comments_to_records
  #   @data ||= get
  #   comments = []
  #   counter = 0
  #   loop do
  #     new_comments = Dcard::Comment.to_records(@data['id'], after: counter)
  #     counter += 100
  #     break if new_comments.blank?
  #
  #     comments += new_comments
  #   end
  #   comments
  # end
end
