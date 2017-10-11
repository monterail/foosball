require File.expand_path "../../spec_helper.rb", __FILE__

# rubocop:disable Metrics/BlockLength
RSpec.describe Team do
  let(:team) { Team.new }
  let(:member_id) { "UID01" }
  let(:member_name) { "user_1" }
  let(:member2_id) { "UID02" }
  let(:member2_name) { "user_2" }
  let(:member3_id) { "UID03" }
  let(:member3_name) { "user_3" }
  let(:member4_id) { "UID04" }
  let(:member4_name) { "user_4" }

  describe "#create" do
    let(:call_method) { team.create(member_id, member_name, members: members) }
    let(:members) { [] }
    let(:slack_users) do
      {
        member_name => member_id,
        member2_name => member2_id,
        member3_name => member3_id,
        member4_name => member4_id,
      }
    end

    before do
      allow_any_instance_of(Slack).to receive(:fetch_users).and_return(slack_users)
    end

    context "when there are no additional players" do
      it "calls NotificationBuilder class" do
        expect(NotificationBuilder).to receive(:new_game).with([member_name])
        call_method
      end

      it "adds member to the team" do
        call_method
        expect(team.members).to eq(member_id => member_name)
      end
    end

    context "when there is one additional player" do
      let(:members) { ["@#{member2_name}"] }
      it "calls NotificationBuilder class" do
        expect(NotificationBuilder).to receive(:new_game).with([member_name, member2_name])
        call_method
      end

      it "adds members to the team" do
        call_method
        expect(team.members).to eq(member_id => member_name, member2_id => member2_name)
      end
    end

    context "when there are two additional players" do
      let(:members) { ["@#{member2_name}", "@#{member3_name}"] }
      it "calls NotificationBuilder class" do
        expect(NotificationBuilder).to receive(:new_game)
          .with([member_name, member2_name, member3_name])
        call_method
      end

      it "adds members to the team" do
        call_method
        expect(team.members).to eq(
          member_id => member_name, member2_id => member2_name, member3_id => member3_name,
        )
      end
    end

    context "when additional member is not in the database or is invalid" do
      let(:invalid_name) { "@invalid_name" }

      context "when invalid member is first param" do
        let(:members) { [invalid_name, "@#{member2_name}"] }

        it "doesn't add invalid user to the team" do
          call_method
          expect(team.members).to eq(member_id => member_name, member2_id => member2_name)
        end
      end

      context "when invalid member is second param" do
        let(:members) { ["@#{member2_name}", invalid_name] }

        it "doesn't add invalid user to the team" do
          call_method
          expect(team.members).to eq(member_id => member_name, member2_id => member2_name)
        end
      end
    end

    context "when a team already exists" do
      before do
        team.members = {
          "some_id" => "some_user",
        }
      end
      it "creates new team" do
        call_method
        expect(team.members).to eq(member_id => member_name)
      end
    end
  end

  describe "#delete_member" do
    before { team.create(member_id, member_name) }

    context "when there is one team member" do
      let(:call_method) { team.delete_member(member_id) }

      it "deletes the user from the team" do
        expect { call_method }.to change(team.members, :size).from(1).to(0)
      end

      it "calls NotificationBuilder class" do
        expect(NotificationBuilder).to receive(:team_status).with([])
        call_method
      end
    end
  end

  describe "#add_member" do
    before { team.create(member_id, member_name) }

    context "when adding 2nd member" do
      let(:call_method) { team.add_member(member2_id, member2_name) }

      it "adds member to the team" do
        call_method
        expect(team.members[member2_id]).to eq(member2_name)
      end

      it "changes team size to 2" do
        call_method
        expect(team.members.size).to eq(2)
      end

      it "calls NotificationBuilder class" do
        expect(NotificationBuilder).to receive(:team_status).with([member_name, member2_name])
        call_method
      end
    end

    context "when adding 3rd member" do
      let(:call_method) { team.add_member(member3_id, member3_name) }
      before { team.members[member2_id] = member2_name }

      it "adds member to the team" do
        call_method
        expect(team.members[member3_id]).to eq(member3_name)
      end

      it "changes team size to 3" do
        call_method
        expect(team.members.size).to eq(3)
      end

      it "calls NotificationBuilder class" do
        expect(NotificationBuilder)
          .to receive(:team_status).with([member_name, member2_name, member3_name])
        call_method
      end
    end

    context "when adding 4th member" do
      let(:call_method) { team.add_member(member4_id, member4_name) }
      before do
        team.members[member2_id] = member2_name
        team.members[member3_id] = member3_name
      end

      it "adds member to the team" do
        call_method
        expect(team.members[member4_id]).to eq(member4_name)
      end

      it "changes team size to 4" do
        call_method
        expect(team.members.size).to eq(4)
      end

      it "calls NotificationBuilder class" do
        expect(NotificationBuilder)
          .to receive(:members_notification).with([member_id, member2_id, member3_id, member4_id])
        call_method
      end
    end

    context "when adding 5th member" do
      let(:call_method) { team.add_member(member5_id, member5_name) }
      let(:member5_id) { "UID05" }
      let(:member5_name) { "user_5" }
      before do
        team.members[member2_id] = member2_name
        team.members[member3_id] = member3_name
        team.members[member4_id] = member4_name
      end

      it "doesn't add member to the team" do
        call_method
        expect(team.members[member5_id]).to eq(nil)
      end

      it "doesn't change team size" do
        call_method
        expect(team.members.size).to eq(4)
      end
    end

    context "when adding the same member" do
      let(:call_method) { team.add_member(member_id, member_name) }

      it "doesn't change the member the team" do
        call_method
        expect(team.members[member_id]).to eq(member_name)
      end

      it "doesn't change team size" do
        call_method
        expect(team.members.size).to eq(1)
      end

      it "calls NotificationBuilder class" do
        expect(NotificationBuilder).to receive(:team_status).with([member_name])
        call_method
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
