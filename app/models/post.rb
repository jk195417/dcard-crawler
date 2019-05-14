class Post < ApplicationRecord
  include Mentionable

  belongs_to :forum, counter_cache: true
  has_one :sentiment, as: :sentimental
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :not_removed, -> { where(removed: nil) }
  scope :crawled, -> { where('comment_count = comments_count') }
  scope :comments_more_then, ->(number) { where('comments_count >= ?', number) }
  scope :reviewable, -> { not_removed.crawled.comments_more_then(10) }
  scope :random, -> { offset(rand(count)) } # need 2 sql query

  validates_uniqueness_of :dcard_id

  def dcard_url
    "https://www.dcard.tw/f/#{forum_alias}/p/#{dcard_id}"
  end

  def floor
    0
  end
end
