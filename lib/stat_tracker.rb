require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

class StatTracker
  attr_reader :games, :teams, :game_team

  def initialize(locations)
    @games = load_games(locations[:games])
    @teams = load_teams(locations[:teams])
    @game_teams = load_game_teams(locations[:game_teams])
  end

  def self.from_csv(locations)
    new(locations)
  end

  def load_games(file_path)
    # Load game data from CSV file and store it as Game objects in an array
  end

  def load_teams(file_path)
    # Load team data from CSV file and store it as Team objects in an array
  end

  def load_game_teams(file_path)
    # Load game team data from CSV file and store it as GameTeam objects in an array
  end

  # Add statistical methods here...
end
