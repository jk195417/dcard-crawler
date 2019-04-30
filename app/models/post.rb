# frozen_string_literal: true

class Post < ApplicationRecord
  include Dcard::LoadData

  belongs_to :forum, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :not_removed, -> { where(removed: nil) }
  scope :crawled, -> { where('comment_count = comments_count') }
  scope :comments_more_then, ->(number) { where('comments_count >= ?', number) }
  scope :reviewable, -> { not_removed.crawled.comments_more_then(10) }
  scope :random, -> { offset(rand(count)) } # need 2 sql query

  validates_uniqueness_of :dcard_id

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
      created_at: Time.parse(data['createdAt']),
      updated_at: Time.parse(data['updatedAt'])
    }
  end

  def dcard_url
    "https://www.dcard.tw/f/#{forum_alias}/p/#{dcard_id}"
  end

  def pull_from_dcard
    response = JSON.parse(HTTP.get(Dcard::Api.post(dcard_id)).to_s)
    if response.fetch('error') { nil }.to_i == 1202
      assign_attributes(removed: response.fetch('reason') { '' })
    else
      load_from_dcard(response)
    end
  end

  def new_comments_from_dcard(after: nil)
    new_comments = []
    api = Dcard::Api.post_comments(dcard_id, after: after)
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
    Rails.logger.error "Error when getting post #{dcard_id} comments from #{api} #{e.inspect}"
    new_comments
  end

  def mentions
    # result = []
    # content&.scan(/B\d+/) { |floor_with_B| result << floor_with_B[1..-1].to_i }
    # result
    content&.scan(/B\d+/) || []
  end

  def floor
    0
  end
end
