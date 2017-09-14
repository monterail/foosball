# frozen_string_literal: true

require "sinatra"
require "pry"
require "json"
require_relative "app/slack_authorizer"
require_relative "app/slack_messenger"
require_relative "app/team"
require_relative "app/notification_builder"

use SlackAuthorizer

team = Team.new

def user_params(params)
  params.values_at("user_id", "user_name")
end

post "/slack/foosball" do
  response = case params["text"].to_s.strip
             when ""     then team.create(*user_params(params))
             when "help" then NotificationBuilder.help
             else NotificationBuilder.help
  end
  SlackMessenger.deliver(response)
end

post "/slack/+" do
  response = team.add_member(*user_params(params))
  SlackMessenger.deliver(response)
end

post "/slack/-" do
  response = team.delete_member(params["user_id"])
  SlackMessenger.deliver(response)
end
