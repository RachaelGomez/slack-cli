require 'test/test_helper'
CONVERSATIONS_LIST_URL = "https://slack.com/api/conversations.list"
class Channel < Recipient
  attr_reader :topic, :member_count,
  def initialize(slack_id, name, topic, member_count)
    super(slack_id, name)
    @topic = topic
    @member_count = member_count
  end

  def details
    return "Channel id: #{@slack_id}\nChannel name: #{@name}\nTopic: #{@topic}\nNumber of members: #{@member_count}"
  end

  def self.list_all
    query = {token: ENV['SLACK_TOKEN']}
    
    request = self.get(CONVERSATIONS_LIST_URL, query )
    
    return request["channels"].map do |channel|
      self.new(channel["id"], channel["name"], channel["purpose"]["value"], channel["num_members"])
    end
  end
end
