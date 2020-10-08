require_relative 'test_helper'
require_relative '../lib/recipient'

describe "Recipient class" do

  describe "instantiation" do

    before do
      @new_recipient = Recipient.new("some_id", "some_name")
    end

    it "is an instance of Recipient" do
      expect(@new_recipient).must_be_instance_of Recipient
    end

    it "establishes the base data structures when instantiated" do
      [:slack_id, :name].each do |keyword|
        expect(@new_recipient).must_respond_to keyword
      end

      expect(@new_recipient.slack_id).must_be_kind_of String
      expect(@new_recipient.name).must_be_kind_of String

    end

  end


  describe "details" do
    before do
      @new_recipient = Recipient.new("some_id", "some_name")
    end

    it "raises an error" do
      expect{@new_recipient.details}.must_raise NotImplementedError
    end
  end

  describe "self.list_all" do
    it "raises an error" do
      expect{Recipient.list_all}.must_raise NotImplementedError
    end
  end

  describe "send message" do
    before do
      @channel_recipient = Recipient.new("C01BKRLQ4UF", "random")
      @user_recipient = Recipient.new("U01C0JB1FB4", "christabot")
      @message = "Testing"
    end

    it "sends a message to a channel" do
      VCR.use_cassette("post message to channel") do
        response = @channel_recipient.send_message(@message)
        expect(response["ok"]).must_equal true
      end
    end

    it "sends a message to a user" do

    end

    it "expect error_message for bad `channel`" do
      VCR.use_cassette("post message to channel -- bad recipient") do
        bad_recipient = Recipient.new("failure", "still a failure")
        expect {
          bad_recipient.send_message(@message)
        }.must_raise ArgumentError
      end
    end

    it "expect error_message for bad `user`" do

    end

    it "expect error_message for nil `text` to a channel" do
      VCR.use_cassette("post message to channel -- nil message") do
        expect {
          @channel_recipient.send_message(nil)
        }.must_raise ArgumentError
      end
    end

    it "expect error_message for nil `text` to a user" do

    end

  end
end