require 'httparty'

POST_URL = "https://slack.com/api/chat.postMessage"

class Recipient
  attr_reader :slack_id, :name

  def initialize(slack_id, name)
    @slack_id = slack_id
    @name = name
  end

  def send_message(message)
    params = {token: ENV['SLACK_TOKEN'], channel: @slack_id, text: message}
    return self.class.error_message(HTTParty.post(POST_URL, body: params))
  end

  def self.get(url, params)
    return error_message(HTTParty.get(url,params))
  end

  def details
    raise NotImplementedError, 'Implement me in a child class!'
  end
  def self.list_all
    raise NotImplementedError, 'Implement me in a child class!'
  end

  private

  def self.error_message(response)
    if response["ok"] != true
      raise ArgumentError, "API request failed with error: #{response["error"]}."
    else
      return response
    end
  end

end