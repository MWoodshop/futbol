require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

class StatTracker
  attr_reader :games, :teams, :game_teams, :seasons, :league

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def initialize(data)
    @games = game_init(data)
    @teams = teams_init(data)
    @game_teams = game_teams_init(data)
    # @seasons = Season.new(@games)           # Might use later, not yet implemented
    # @league = League.new(@teams, @games)    # Might use later, not yet implemented
    # @game_stats = GameStats.new(@teams)     # Might use later, not yet implemented
  end

  def game_init(data)
    CSV.read(data[:games], headers: true, header_converters: :symbol).map { |row| Game.new(row) }
  end

  def teams_init(data)
    CSV.read(data[:teams], headers: true, header_converters: :symbol).map { |row| Team.new(row) }
  end

  def game_teams_init(data)
    CSV.read(data[:game_teams], headers: true, header_converters: :symbol).map { |row| GameTeam.new(row) }
  end

  # GAME STATS

  def highest_total_score
    output = @games.max do |game1, game2|
      # require 'pry'; binding.pry
      (game1.away_goals + game1.home_goals) <=> (game2.away_goals + game2.home_goals)
    end
    output.away_goals + output.home_goals
  end

  def home_win?
    @games.count { |game| game.home_goals > game.away_goals }
  end

  def percentage_home_wins
    (home_win?.to_f / @games.size).round(2)
  end

  def away_win?
    @games.count { |game| game.away_goals > game.home_goals }
  end

  def percentage_visitor_wins
    (away_win?.to_f / @games.size).round(2)
  end
end
