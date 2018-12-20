class Post < ActiveRecord::Base
  belongs_to :forum, counter_cache: true
  has_many :comments, dependent: :destroy

  scope :not_removed, -> { where(removed: nil) }

  def self.load_from_dcard(data)
    {
      dcard_id: data['id'],
      reply_id: data['replyId'],
      comment_count: data['commentCount'],
      like_count: data['likeCount'],
      title: data['title'],
      content: data['content'],
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
      updated_at: DateTime.parse(data['updatedAt'])
    }
  end

  def api
    DcardAPI.post(dcard_id)
  end

  def load_from_dcard(data)
    new_values = self.class.load_from_dcard(data)
    assign_attributes(new_values)
  end

  def pull_from_dcard
    load_from_dcard(JSON.parse(HTTP.get(api).to_s))
  end

  def new_comments_from_dcard(after: nil)
    new_comments = []
    api = DcardAPI.post_comments(dcard_id, after: after)
    comments = JSON.parse(HTTP.get(api).to_s)

    # check post not removed
    unless comments.is_a?(Array)
      if comments.fetch('error') { nil }.to_i == 1202
        reason = comments.fetch('reason') { '' }
        update!(removed: reason)
      end
      return new_comments
    end

    # check comments present
    return new_comments if comments.blank?

    comments.each do |comment|
      new_comment = Comment.load_from_dcard(comment)
      new_comment[:post_id] = id
      new_comments << new_comment
    end
    new_comments
  rescue StandardError => e
    App.logger.error "Error when getting post #{dcard_id} comments from #{api} #{e.inspect}"
    new_comments
  end
end
