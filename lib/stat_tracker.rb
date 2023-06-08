require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'season'
require_relative 'league'

class StatTracker
  attr_reader :games, :teams, :seasons

  def initialize(locations)
    @games = load_games(locations[:games])
    @teams = load_teams(locations[:teams])
    @seasons = load_seasons(@games)
  end

  def self.from_csv(locations)
    new(locations)
  end

  def load_games(file_path)
    games = []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      games << Game.new(row)
    end
    games
    # Load game data from CSV file and store it as Game objects in an array
  end

  def load_teams(file_path)
    # Load team data from CSV file and store it as Team objects in an array
  end

  def load_seasons(file_path)
    # Group games by season and store it as Season objects in an array
  end

  # Add statistical methods here...

  def percentage_home_wins
    home_wins = @games.count(&:home_win?)
    (home_wins.to_f / @games.size).round(2)
  end

  def percentage_visitor_wins
    visitor_wins = @games.count(&:visitor_win?)
    (visitor_wins.to_f / @games.size).round(2)
  end
end
