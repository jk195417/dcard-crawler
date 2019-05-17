# Usage:
#
# aip = Baidu::Aip.new
# aip.sentiment(text)
#
# Return a hash:
#
# {
#   "positive_prob": 0.566052, # 為正面的機率，值介於 0~1
#   "confidence": 0.0356713, # 信心程度，值介於 0~1
#   "negative_prob": 0.433948, # 為負面的機率，值介於 0~1
#   "sentiment": 2 # 0 負面，1 中性，2 正面
# }

class Baidu::Aip
  attr_reader :host, :api_key, :secret_key

  def initialize
    @host = 'https://aip.baidubce.com'
    keys = Rails.application.credentials.fetch(:baidu_aip) { raise 'Please setup Rails.application.credentials[:baidu_aip] first' }
    @api_key = keys.fetch(:api_key) { raise 'Please setup Rails.application.credentials[:baidu_aip][:api_key] first' }
    @secret_key = keys.fetch(:secret_key) { raise 'Please setup Rails.application.credentials[:baidu_aip][:secret_key] first' }
    @redis = Redis.new
  rescue Redis::CannotConnectError
    @redis = nil
  end

  def access_token
    @access_token ||= @access_token
    begin
      @access_token ||= @redis.get(:baidu_aip_access_token)
    rescue Redis::CannotConnectError => e
      Rails.logger.error { e }
    end
    @access_token ||= request_access_token
    @access_token
  end

  def sentiment(text)
    Rails.logger.debug { "Baidu::Aip.new.sentiment(text), text can\'t be blank." } && return if text.blank?
    if text.bytesize > 2048
      Rails.logger.info { "Baidu::Aip.new.sentiment(text), text byte can't >= 2048, we will using its first 2048 byte to run analysis" }
      text = text.byteslice(0..2048)[0..-2]
    end
    params = { charset: 'UTF-8', access_token: access_token, client_secret: @secret_key }
    body = { text: text }
    response = HTTP.post("#{@host}/rpc/2.0/nlp/v1/sentiment_classify?#{params.to_query}", json: body)
    # Response json look like:
    # {
    #   "log_id": 4703034185884062249,
    #   "text": '剛剛那家餐廳蠻好吃的，我們下次再約個時間來吃第二次吧！',
    #   "items": [
    #     {
    #       "positive_prob": 0.566052,
    #       "confidence": 0.0356713,
    #       "negative_prob": 0.433948,
    #       "sentiment": 2
    #     }
    #   ]
    # }
    result = JSON.parse(response.to_s)
    result['items'].first
  rescue StandardError
    Rails.logger.error { "text=\n#{text}" }
    Rails.logger.error { "response=\n#{response}" }
    false
  end

  private

  def authenticate
    params = {
      grant_type: 'client_credentials',
      client_id: api_key,
      client_secret: secret_key
    }
    response = HTTP.post("#{@host}/oauth/2.0/token?#{params.to_query}")
    # Response json look like:
    # {
    #   "refresh_token": '25.b55fe1d287227ca97aab219bb249b8ab.315360000.1798284651.282335-8574074',
    #   "expires_in": 2592000,
    #   "scope": 'public wise_adapt',
    #   "session_key": '9mzdDZXu3dENdFZQurfg0Vz8slgSgvvOAUebNFzyzcpQ5EnbxbF+hfG9DQkpUVQdh4p6HbQcAiz5RmuBAja1JJGgIdJI',
    #   "access_token": '24.6c5e1ff107f0e8bcef8c46d3424a0e78.2592000.1485516651.282335-8574074',
    #   "session_secret": 'dfac94a3489fe9fca7c3221cbf7525ff'
    # }
    JSON.parse(response.to_s)
  end

  def request_access_token
    auth = authenticate
    begin
      @redis.set(:baidu_aip_access_token, auth['access_token'], ex: auth['expires_in'])
    rescue Redis::CannotConnectError => e
      Rails.logger.error { e }
    end
    auth['access_token']
  end
end
