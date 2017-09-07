require 'sinatra'
require 'pry'
require_relative 'app/slack_authorizer'
require_relative 'app/team'

use SlackAuthorizer

team = Team.new

post '/slack/foosball' do
  team.create(params["user_name"])
  "@here Let's play a game.\nTeam status: #{team.members_list}"
end

post '/slack/+' do
  notification = team.add_member(params["user_name"])
  "Team status: #{team.members_list}\n#{notification}"
end

post '/slack/-' do
  team.delete_member(params["user_name"])
  "Team status: #{team.members_list}"
end
