# frozen_string_literal: true

require "sinatra"
require "pry"
require "json"
require_relative "app/slack_authorizer"
require_relative "app/slack"
require_relative "app/team"
require_relative "app/notification_builder"

use SlackAuthorizer

team = Team.new

def user_params(params)
  params.values_at("user_id", "user_name")
end

def parse_text_params(params)
  params["text"].to_s.strip.split(" ")[0..1]
end

post "/slack/foosball" do
  founder_params = user_params(params)
  text_params = parse_text_params(params)

  response = case text_params.first
             when nil then team.create(*founder_params)
             when "help" then NotificationBuilder.help
             else team.create(*founder_params, members: text_params)
  end
  Slack.deliver(response)
end

post "/slack/+" do
  response = team.add_member(*user_params(params))
  Slack.deliver(response)
end

post "/slack/-" do
  response = team.delete_member(params["user_id"])
  Slack.deliver(response)
end
