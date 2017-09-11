class Notifier
  class << self
    def new_game
      deliver("<!here> Let's play a game")
    end

    def team_status(members)
      deliver("Team status: #{members}")
    end

    def notify_players
      deliver("#{notification} GO!")
    end

    def help
      deliver("`/foosball` start a game\n`/+` join the game\n`/-` leave the game")
    end

    private

    def deliver(msg)
      SlackMessenger.deliver(msg)
    end
  end
end
