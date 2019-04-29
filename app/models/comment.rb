# frozen_string_literal: true

class Comment < ApplicationRecord
  include Dcard::LoadData

  belongs_to :post, counter_cache: true

  def self.load_from_dcard(data)
    {
      dcard_id: data['id'],
      anonymous: data['anonymous'],
      post_dcard_id: data['postId'],
      created_at: Time.parse(data['createdAt']),
      updated_at: Time.parse(data['updatedAt']),
      floor: data['floor'],
      content: data['content'],
      like_count: data['likeCount'],
      with_nickname: data['withNickname'],
      hidden_by_author: data['hiddenByAuthor'],
      gender: data['gender'],
      school: data['school'],
      department: data['department'],
      host: data['host'],
      report_reason: data['reportReason'],
      hidden: data['hidden'],
      in_review: data['inReview']
    }
  end

  def mentions
    # result = []
    # content&.scan(/B\d+/) { |floor_with_B| result << floor_with_B[1..-1].to_i }
    # result
    content&.scan(/B\d+/) || []
  end
end
