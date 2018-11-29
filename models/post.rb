class Post < Sequel::Model
  many_to_one :forum
  one_to_many :comments

  def self.load_from_dcard(data)
    { dcard_id: data['id'],
      reply_id: data['replyId'],
      comment_count: data['commentCount'],
      like_count: data['likeCount'],
      title: data['title'],
      excerpt: data['excerpt'],
      tags: data['tags'].to_s,
      topics: data['topics'].to_s,
      forum_name: data['forumName'],
      forum_alias: data['forumAlias'],
      gender: data['gender'],
      school: data['school'],
      department: data['department'],
      reply_title: data['replyTitle'],
      reactions: data['reactions'].to_s,
      custom_style: data['customStyle'].to_s,
      media: data['media'].to_s,
      anonymous_school: data['anonymousSchool'],
      anonymous_department: data['anonymousDepartment'],
      pinned: data['pinned'],
      with_nickname: data['withNickname'],
      hidden: data['hidden'],
      with_images: data['withImages'],
      with_videos: data['withVideos'],
      created_at: DateTime.parse(data['createdAt']),
      updated_at: DateTime.parse(data['updatedAt']) }
  end

  def self.oldest(forum_id: nil)
    result = Post
    result = result.where(forum_id: forum_id) if forum_id
    result.order(Sequel.asc(:dcard_id)).first
  end

  def load_from_dcard(data)
    self.class.new(self.class.load_from_dcard(data))
  end
end
