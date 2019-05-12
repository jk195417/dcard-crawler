# https://github.com/hanxiao/bert-as-service#using-bert-as-service-to-serve-http-requests-in-json
#
# Usage:
#
# bc = Bert::Service.new
# bc.perform(uniq_key, texts_array)
#
# Return an Array:
# [0.123124, -0.98872123, ...]

class Bert::Service
  attr_accessor :host

  def initialize(host: nil)
    @host = host || Rails.application.credentials.bert_as_service[:url] || 'http://0.0.0.0:8125'
  end

  # texts = [text1, text2...], texts.size need to <= 256
  def perform(id, texts, is_tokenized: false)
    params = { id: id, texts: texts, is_tokenized: is_tokenized }
    response = HTTP.post("#{@host}/encode", json: params)
    embeddings = JSON.parse(response.to_s)['result']
    embeddings
  end
end
