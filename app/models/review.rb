class Review < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :post, counter_cache: true
  enum echo_chamber: { not_sure: -1, no: 0, weak: 1, little: 2, yes: 3, strong: 4, heavy: 5 }
  validates_presence_of :echo_chamber
end
