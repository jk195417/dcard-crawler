class Forum < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates_uniqueness_of :alias, :dcard_id, :name

  def dcard_url
    'https://www.dcard.tw/f/' + self.alias
  end
end
