# frozen_string_literal: true

# https://github.com/jk195417/chinese-segmentation-as-service
#
# Usage:
# sc = Segmentation::Service.new
# segmentation = sc.perform("要斷詞的中文", method)
# there is 3 method for segmentation : 'snownlp', 'jieba', 'pkuseg'

class Segmentation::Service
  attr_accessor :host

  def initialize(host: nil)
    @host = host || Rails.application.credentials.dig('chinese_segmentation_as_service', 'url') || 'http://0.0.0.0:3001'
  end

  def perform(text, method = 'jieba')
    params = { text: text }
    response = HTTP.post("#{@host}/segmentations", json: params)
    segmentations = JSON.parse(response.to_s)
    segmentations[method]
  end
end
