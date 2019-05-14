class Sentiment < ApplicationRecord
  belongs_to :sentimental, polymorphic: true
end
