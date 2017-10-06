require File.expand_path "../spec_helper.rb", __FILE__

# rubocop:disable Metrics/BlockLength
describe "AppController" do
  let(:user_id) { "UID01" }
  let(:user_name) { "user_1" }
  describe "POST 'slack/foosball'" do
    let(:call_api) do
      allow_any_instance_of(SlackMessenger).to receive(:deliver).and_return(nil)
      post "/slack/foosball", user_id: user_id, user_name: user_name, text: text
    end

    context "when there is no text param" do
      let(:text) { "" }
      it "Creates a new team" do
        expect_any_instance_of(Team).to receive(:create).with(user_id, user_name)
        call_api
      end

      it "Sends the message to slack" do
        expect(SlackMessenger).to receive(:deliver)
        call_api
      end
    end

    context "when text param is 'help'" do
      let(:text) { "help" }
      it "Creates a new team" do
        expect(NotificationBuilder).to receive(:help)
        call_api
      end

      it "Sends the message to slack" do
        expect(SlackMessenger).to receive(:deliver)
        call_api
      end
    end

    context "when text param is invalid" do
      let(:text) { "help" }
      it "Creates a new team" do
        expect(NotificationBuilder).to receive(:help)
        call_api
      end

      it "Sends the message to slack" do
        expect(SlackMessenger).to receive(:deliver)
        call_api
      end
    end
  end

  describe "POST 'slack/+'" do
    let(:call_api) do
      allow_any_instance_of(SlackMessenger).to receive(:deliver).and_return(nil)
      post "/slack/+", user_id: user_id, user_name: user_name
    end

    it "Adds member to the team" do
      expect_any_instance_of(Team).to receive(:add_member).with(user_id, user_name)
      call_api
    end

    it "Sends the message to slack" do
      expect(SlackMessenger).to receive(:deliver)
      call_api
    end
  end

  describe "POST 'slack/-'" do
    let(:call_api) do
      allow_any_instance_of(SlackMessenger).to receive(:deliver).and_return(nil)
      post "/slack/-", user_id: user_id, user_name: user_name
    end

    it "Deletes member from the team" do
      expect_any_instance_of(Team).to receive(:delete_member).with(user_id)
      call_api
    end

    it "Sends the message to slack" do
      expect(SlackMessenger).to receive(:deliver)
      call_api
    end
  end
end
# rubocop:enable Metrics/BlockLength
