class Sentiment < ApplicationRecord
  belongs_to :sentimental, polymorphic: true
  enum sentiment: { negative: 0, neutral: 1, positive: 2 }
end
