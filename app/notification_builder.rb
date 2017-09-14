# frozen_string_literal: true

class NotificationBuilder
  class << self
    def new_game(members)
      "<!here> Let's play a game\n#{team_status(members)}"
    end

    def team_status(members)
      "Team status: #{members_list(members)}"
    end

    def members_notification(members)
      notification = members.sort.map { |member| "<@#{member}>" }.join(", ")
      "#{notification} GO!"
    end

    def help
      "`/foosball` start a game\n`/+` join the game\n`/-` leave the game"
    end

    private

    def members_list(members)
      members.sort.join(", ")
    end
  end
end
