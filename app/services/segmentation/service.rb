# https://github.com/jk195417/chinese-segmentation-as-service
#
# Usage:
#
# sc = Segmentation::Service.new
# segmentation = sc.perform("要斷詞的中文")
#
# Return an Array:
# ['要', '斷詞', '的', '中文']

class Segmentation::Service
  attr_accessor :host

  def initialize(host: nil)
    @host = host || Rails.application.credentials.dig(:chinese_segmentation_as_service, :url) || 'http://0.0.0.0:3001'
  end

  # There is 3 method for segmentation : 'snownlp', 'jieba', 'pkuseg'
  def perform(text, method = 'jieba')
    params = { text: text, lib: method }
    response = HTTP.post("#{@host}/segmentations", json: params)
    JSON.parse(response.to_s)['result']
  end
end
