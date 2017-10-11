# frozen_string_literal: true

class Team
  attr_accessor :members

  def create(founder_id, founder_name, members: [])
    @members = {}
    @members[founder_id] = founder_name
    members.each do |member_name|
      member_name[0] = ""
      member_id = slack_users[member_name]
      @members[member_id] = member_name if member_id
    end
    NotificationBuilder.new_game(member_names)
  end

  def add_member(member_id, member_name)
    return if @members.size == 4
    @members[member_id] = member_name
    return NotificationBuilder.members_notification(member_ids) if members.size == 4
    NotificationBuilder.team_status(member_names)
  end

  def delete_member(member_id)
    @members.delete(member_id)
    NotificationBuilder.team_status(member_names)
  end

  private

  def member_names
    @members.values
  end

  def member_ids
    @members.keys
  end

  def slack_users
    @slack_users ||= Slack.fetch_users
  end
end
