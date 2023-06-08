require 'csv'
require_relative 'csv_headers'

class Game
  include CSVHeaders

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

  def percentage_home_wins
    total_games = @games.size
    return 0 if total_games.zero?

    (home_team_wins.to_f / total_games * 100).round(2)
  end
end

# # Debugging begin
# game = Game.new
# puts game.percentage_home_wins
# # Debugging end
