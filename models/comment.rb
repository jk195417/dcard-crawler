class Comment < Sequel::Model
  many_to_one :post

  def self.load_from_dcard(data)
    {
      dcard_id: data['id'],
      anonymous: data['anonymous'],
      dcard_post_id: data['postId'],
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

  def self.latest(dcard_post_id)
    Comment.where(dcard_post_id: dcard_post_id).order(Sequel.desc(:floor)).first
  end

  def load_from_dcard(data)
    self.class.new(self.class.load_from_dcard(data))
  end
end
