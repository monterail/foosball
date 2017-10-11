# frozen_string_literal: true

require "httpclient"
class Slack
  SLACK_MESSAGE_HOOK = ENV["SLACK_API"]
  SLACK_USERS_API = ENV["SLACK_USERS_API"]

  def self.deliver(message)
    new.deliver(message)
  end

  def self.fetch_users
    new.fetch_users
  end

  def initialize
    @client = HTTPClient.new
  end

  def deliver(message)
    @client.post(SLACK_MESSAGE_HOOK, msg_params(message).to_json)
  end

  def fetch_users
    response = @client.get(SLACK_USERS_API, token_param)
    users = JSON.parse(response.body)["members"]
    users_hash = {}
    users.each do |user|
      users_hash[user["name"]] = user["id"]
    end
    users_hash
  end

  private

  def msg_params(message)
    { text: message.to_s }.merge(token_param)
  end

  def token_param
    { token: ENV["SLACK_OAUTH"] }
  end
end
