# frozen_string_literal: true

require "httpclient"
class SlackMessenger
  SLACK_API = ENV["SLACK_API"]

  def self.deliver(message)
    new(message).deliver
  end

  def initialize(message)
    @message = message
  end

  def deliver
    client = HTTPClient.new
    client.post(SLACK_API, params.to_json)
  end

  def params
    {
      token: ENV["SLACK_OAUTH"],
      text: @message,
    }
  end
end
