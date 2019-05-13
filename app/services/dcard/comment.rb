# Usage :
# Dcard::Comment.to_records Dcard::Comment.get(post_dcard_id)
#
# Return :
# A Comments(without saved) Array.

class Dcard::Comment
  attr_accessor :data

  def initialize(data)
    @data = data
  end

  def self.get(post_dcard_id, **options)
    url = Dcard::API.post_comments(post_dcard_id, options)
    puts "GET #{url}"
    JSON.parse(HTTP.get(url).to_s)
  end

  def self.to_records(json_array)
    json_array.map { |comment| new(comment).to_record }
  end

  def to_record
    ::Comment.new do |it|
      it.dcard_id = @data['id']
      it.anonymous = @data['anonymous']
      it.post_dcard_id = @data['postId']
      it.created_at = Time.parse(@data['createdAt'])
      it.updated_at = Time.parse(@data['updatedAt'])
      it.floor = @data['floor']
      it.content = @data['content']
      it.like_count = @data['likeCount']
      it.with_nickname = @data['withNickname']
      it.hidden_by_author = @data['hiddenByAuthor']
      it.gender = @data['gender']
      it.school = @data['school']
      it.department = @data['department']
      it.host = @data['host']
      it.report_reason = @data['reportReason']
      it.hidden = @data['hidden']
      it.in_review = @data['inReview']
    end
  end
end
