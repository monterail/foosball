require "sinatra"
require "pry"
require "json"
require_relative "app/slack_authorizer"
require_relative "app/slack_messenger"
require_relative "app/team"

use SlackAuthorizer

team = Team.new

post "/slack/foosball" do
  team.create(params["user_name"])
  SlackMessenger.deliver("<!here> Let's play a game")
  "Team status: #{team.members_list}"
end

post "/slack/+" do
  notification = team.add_member(params["user_name"])
  return SlackMessenger.deliver("#{notification} GO!") if notification
  SlackMessenger.deliver("Team status: #{team.members_list}")
end

post "/slack/-" do
  team.delete_member(params["user_name"])
  SlackMessenger.deliver("Team status: #{team.members_list}")
end
