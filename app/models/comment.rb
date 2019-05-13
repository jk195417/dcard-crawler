class Comment < ApplicationRecord
  include Mentionable

  belongs_to :post, counter_cache: true
end
