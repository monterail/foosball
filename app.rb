# frozen_string_literal: true

require "sinatra"
require "pry"
require "json"
require_relative "app/slack_authorizer"
require_relative "app/slack_messenger"
require_relative "app/team"
require_relative "app/notifier"

use SlackAuthorizer

team = Team.new

post "/slack/foosball" do
  return Notifier.help unless params["text"].to_s.strip.empty?
  team.create(params["user_name"])
  Notifier.new_game
  Notifier.team_status(team.members_list)
end

post "/slack/+" do
  notification = team.add_member(params["user_name"])
  return Notifier.notify_players if notification
  Notifier.team_status(team.members_list)
end

post "/slack/-" do
  team.delete_member(params["user_name"])
  Notifier.team_status(team.members_list)
end
