class Team
  attr_accessor :members

  def initialize()
    @members = []
  end

  def create(initiator)
    @members = [initiator]
  end

  def add_member(member)
    return if members.include? member
    @members << member
    members_notification if members.size == 4
  end

  def delete_member(member)
    @members.delete(member)
  end

  def members_list
    @members.sort.join(", ")
  end

  private

  def members_notification
    @members.sort.map { |member| "<@#{member}>" }.join(", ")
  end
end
