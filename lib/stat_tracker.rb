require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'season'
require_relative 'league'
require_relative 'game_team'

class StatTracker
  attr_reader :games, :teams, :seasons, :league

  def initialize(locations)
    @game_teams_by_game_id = load_game_teams(locations[:game_teams])
    @games = load_games(locations[:games])
    @teams = load_teams(locations[:teams])
    @seasons = load_seasons(@games)
    @league = League.new(@teams, @games)
  end

  def self.from_csv(locations)
    new(locations)
  end

  # Load game data from CSV file and store it as Game objects in an array
  def load_games(file_path)
    games = []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      game_teams = @game_teams_by_game_id[row[:game_id]] || []
      game = Game.new(row, game_teams)
      games << game
    end
    games
  end

  # Load team data from CSV file and store it as Team objects in an array
  def load_teams(file_path)
    teams = []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      teams << Team.new(row)
    end
    teams
  end

  # Group games by season and store it as Season objects in an array
  def load_seasons(games)
    games.group_by(&:season_id).map do |season_id, games_in_season|
      [season_id, Season.new(season_id, games_in_season)]
    end.to_h
  end

  def load_game_teams(file_path)
    game_teams_by_game_id = Hash.new { |hash, key| hash[key] = [] }
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      game_team = GameTeam.new(row)
      game_teams_by_game_id[game_team.game_id] << game_team
    end
    game_teams_by_game_id
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

  def count_of_teams
    @league.count_of_teams
  end

  def winningest_coach(season_id)
    @seasons[season_id].winningest_coach
  end

  def worst_coach(season_id)
    @seasons[season_id].worst_coach
  end
end
