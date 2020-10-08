POST_URL = "https://slack.com/api/chat.postMessage"
class Recipient
  attr_reader :slack_id, :name

  def initialize(slack_id, name)
    @slack_id = slack_id
    @name = name
  end

  def send_message(message)
    params = {token: ENV['SLACK_TOKEN'], channel: @slack_id, text: message}
    sleep(1)
    puts params
    # return self.class.error_message(HTTParty.post(POST_URL,params))
    puts HTTParty.post(POST_URL,params)
  end

  def self.get(url, params)
    sleep(1)
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
    if response.code != 200 || response["ok"] != true
      raise ArgumentError, "API request failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end