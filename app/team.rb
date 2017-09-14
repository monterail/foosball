# frozen_string_literal: true

class Team
  attr_accessor :members

  def create(member_id, member_name)
    @members = {}
    @members[member_id] = member_name
    NotificationBuilder.new_game(member_names)
  end

  def add_member(member_id, member_name)
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
end
