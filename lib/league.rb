class League
  attr_reader :teams, :games

  def initialize(teams, games)
    @teams = teams
    @games = games
  end

  def home_wins
    games.count(&:home_win?)
  end

  def visitor_wins
    games.count(&:visitor_win?)
  end

  def total_games
    games.count
  end
end
