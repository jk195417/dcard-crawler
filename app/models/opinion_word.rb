class OpinionWord < ApplicationRecord
  validates_presence_of :word
  validates_uniqueness_of :word
end
