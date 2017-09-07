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
    notify_members if members.size == 4
  end

  def delete_member(member)
    @members.delete(member)
    @members
  end

  def members_list
    @members.join(", ")
  end

  private

  def notify_members
    @members.map { |member| "<@#{member}>" }.join(", ")
  end
end
