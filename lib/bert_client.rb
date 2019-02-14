# https://github.com/hanxiao/bert-as-service#using-bert-as-service-to-serve-http-requests-in-json
# Usage:
# bc = BertClient.new
# bc.encode(uniq_key, texts_array)
class BertClient
  attr_accessor :host

  def initialize(host: nil)
    @host = host || ENV['BERT_AS_SERVICE_URL'] || 'http://0.0.0.0:8125'
  end

  # texts = [text1, text2...], texts.size need to <= 256
  def encode(id, texts, is_tokenized: false)
    params = { id: id, texts: texts, is_tokenized: is_tokenized }
    response = HTTP.post("#{@host}/encode", json: params)
    embeddings = JSON.parse(response.to_s)['result']
  end
end
