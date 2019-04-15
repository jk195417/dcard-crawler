# https://github.com/jk195417/chinese-segmentation-as-service
# 
# Usage:
# sc = Segmentation::Client.new
# segmentations = sc.segment("要斷詞的中文")
# 
# there is 3 method for segmentation :
# segmentations["jieba"], segmentations["pkuseg"], segmentations["snownlp"]
#
# remove \n and multi blank:
# segmentations["jieba"].gsub(/\n/, '').gsub(/ +/, ' ')


class Segmentation::Client
  attr_accessor :host

  def initialize(host: nil)
    @host = host || Rails.application.credentials.dig("chinese_segmentation_as_service", "url") || 'http://0.0.0.0:3001'
  end

  def segment(text)
    params = { text: text }
    response = HTTP.post("#{@host}/segmentations", json: params)
    segmentations = JSON.parse(response.to_s)
    return segmentations
  end
end


