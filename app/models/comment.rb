class Comment < ApplicationRecord
  include Mentionable

  belongs_to :post, counter_cache: true
  has_one :sentiment, as: :sentimental, dependent: :destroy
end
