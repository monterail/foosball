require File.expand_path "../spec_helper.rb", __FILE__

# rubocop:disable Metrics/BlockLength
describe "AppController" do
  let(:user_id) { "UID01" }
  let(:user_name) { "user_1" }

  describe "POST 'slack/foosball'" do
    let(:call_api) do
      allow_any_instance_of(Slack).to receive(:deliver).and_return(nil)
      post "/slack/foosball", user_id: user_id, user_name: user_name, text: text
    end
    let(:member2_id) { "UID02" }
    let(:member2_name) { "user_2" }
    let(:member3_id) { "UID03" }
    let(:member3_name) { "user_3" }
    let(:member4_id) { "UID04" }
    let(:member4_name) { "user_4" }
    let(:slack_users) do
      {
        user_name => user_id,
        member2_name => member2_id,
        member3_name => member3_id,
        member4_name => member4_id,
      }
    end

    before do
      allow_any_instance_of(Slack).to receive(:fetch_users).and_return(slack_users)
    end

    context "when there is no text param" do
      let(:text) { "" }
      it "Creates a new team" do
        expect_any_instance_of(Team).to receive(:create).with(user_id, user_name)
        call_api
      end

      it "Sends the message to slack" do
        expect(Slack).to receive(:deliver)
        call_api
      end
    end

    context "when text param is additional members" do
      context "when there is one additional member" do
        let(:text) { "@user2" }

        it "Creates a new team" do
          expect_any_instance_of(Team).to receive(:create)
            .with(user_id, user_name, members: ["@user2"])
          call_api
        end

        it "Sends the message to slack" do
          expect(Slack).to receive(:deliver)
          call_api
        end
      end

      context "when there are two additional members" do
        let(:text) { "@user2 @user3" }

        it "Creates a new team" do
          expect_any_instance_of(Team).to receive(:create)
            .with(user_id, user_name, members: ["@user2", "@user3"])
          call_api
        end

        it "Sends the message to slack" do
          expect(Slack).to receive(:deliver)
          call_api
        end
      end

      context "when there are three additional members" do
        let(:text) { "@user2 @user3 @user4" }

        it "Creates a new team with only 3 members" do
          expect_any_instance_of(Team).to receive(:create)
            .with(user_id, user_name, members: ["@user2", "@user3"])
          call_api
        end

        it "Sends the message to slack" do
          expect(Slack).to receive(:deliver)
          call_api
        end
      end
    end

    context "when text param is 'help'" do
      let(:text) { "help" }
      it "Gets help message" do
        expect(NotificationBuilder).to receive(:help)
        call_api
      end

      it "Sends the message to slack" do
        expect(Slack).to receive(:deliver)
        call_api
      end
    end
  end

  describe "POST 'slack/+'" do
    let(:call_api) do
      allow_any_instance_of(Slack).to receive(:deliver).and_return(nil)
      post "/slack/+", user_id: user_id, user_name: user_name
    end

    it "Adds member to the team" do
      expect_any_instance_of(Team).to receive(:add_member).with(user_id, user_name)
      call_api
    end

    it "Sends the message to slack" do
      expect(Slack).to receive(:deliver)
      call_api
    end
  end

  describe "POST 'slack/-'" do
    let(:call_api) do
      allow_any_instance_of(Slack).to receive(:deliver).and_return(nil)
      post "/slack/-", user_id: user_id, user_name: user_name
    end

    it "Deletes member from the team" do
      expect_any_instance_of(Team).to receive(:delete_member).with(user_id)
      call_api
    end

    it "Sends the message to slack" do
      expect(Slack).to receive(:deliver)
      call_api
    end
  end
end
# rubocop:enable Metrics/BlockLength
