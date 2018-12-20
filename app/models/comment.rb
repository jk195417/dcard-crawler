class Comment < ActiveRecord::Base
  belongs_to :post, counter_cache: true

  def self.load_from_dcard(data)
    {
      dcard_id: data['id'],
      anonymous: data['anonymous'],
      post_dcard_id: data['postId'],
      created_at: DateTime.parse(data['createdAt']),
      updated_at: DateTime.parse(data['updatedAt']),
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
      in_review: data['inReview'],
    }
  end

  def load_from_dcard(data)
    new_values = self.class.load_from_dcard(data)
    assign_attributes(new_values)
  end
end
