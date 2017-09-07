require 'sinatra'
require_relative 'app/slack_authorizer'

use SlackAuthorizer

post '/slack/foosball' do
  "Match opened"
end

post '/slack/+' do
  "Joined the team"
end

post '/slack/-' do
  "Left the team"
end
