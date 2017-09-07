require "httpclient"
class SlackMessenger
  SLACK_API_ENDPOINT = "https://hooks.slack.com/services/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".freeze

  def self.deliver(message)
    new(message).deliver
  end

  def initialize(message)
    @message = message
  end

  def deliver
    client = HTTPClient.new
    client.post(SLACK_API_ENDPOINT, params.to_json)
  end

  def params
    {
       token: ENV["SLACK_OAUTH"],
       text: @message,
    }
  end
end
