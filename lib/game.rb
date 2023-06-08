require 'csv'

class Game
  attr_reader :games

  def initialize
    @games = []
    data = CSV.parse(File.read('./data/games.csv'), headers: true, header_converters: :symbol)

    data.each do |row|
      game = {
        game_id: row[:game_id],
        season_id: row[:season],
        game_date: row[:date_time],
        away_team_id: row[:away_team_id],
        home_team_id: row[:home_team_id],
        away_goals: row[:away_goals].to_i,
        home_goals: row[:home_goals].to_i,
        venue_name: row[:venue],
        venue_api_url: row[:venue_link]
      }
      @games << game
    end
  end

  def home_team_wins
    home_wins = 0
    @games.each do |game|
      home_wins += 1 if game[:home_goals] > game[:away_goals]
    end
    home_wins
  end

  def away_team_wins
    away_wins = 0
    @games.each do |game|
      away_wins += 1 if game[:away_goals] > game[:home_goals]
    end
    away_wins
  end

  def percentage_home_wins
    total_games = @games.size
    return 0 if total_games.zero?

    (home_team_wins.to_f / total_games * 100).round(2)
  end

  def percentage_away_wins
    total_games = @games.size
    return 0 if total_games.zero?

    (away_team_wins.to_f / total_games * 100).round(2)
  end
end

# # Debugging begin
# game = Game.new
# puts game.percentage_home_wins
# # Debugging end
