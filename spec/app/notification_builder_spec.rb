require File.expand_path "../../spec_helper.rb", __FILE__

# rubocop:disable Metrics/BlockLength
RSpec.describe NotificationBuilder do
  let(:team_status) { NotificationBuilder.team_status(members.values) }
  let(:members) do
    {
      "UID01" => "user_1",
      "UID02" => "user_2",
    }
  end

  describe "#team_status" do
    it "returns correct team status string" do
      expect(team_status).to eq("Team status: user_1, user_2")
    end
  end

  describe "#new_game" do
    it "returns correct new game and team status string" do
      result = NotificationBuilder.new_game(members.values)
      expect(result).to eq("<!here> Let's play a game\n#{team_status}")
    end
  end

  describe "#members_notification" do
    it "returns correct members notification string" do
      result = NotificationBuilder.members_notification(members.keys)
      expect(result).to eq("<@UID01>, <@UID02> GO!")
    end
  end

  describe "#help" do
    it "returns correct help string" do
      result = NotificationBuilder.help
      expect(result).to eq("`/foosball` start a game\n`/foosball @user1 @user2` "\
        "start a game with friends\n`/+` join the game\n`/-` leave the game")
    end
  end
end
# rubocop:enable Metrics/BlockLength
