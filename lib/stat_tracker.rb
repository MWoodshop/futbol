require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

require 'csv'

class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = []
    @teams = []
    @game_teams = []

    import_data(locations[:games], locations[:teams], locations[:game_teams])
  end

  def import_data(games_path, teams_path, game_teams_path)
    @games = CSV.read(games_path, headers: true, header_converters: :symbol).map do |row|
      Game.new(row.to_h)
    end

    @teams = CSV.read(teams_path, headers: true, header_converters: :symbol).map do |row|
      Team.new(row.to_h)
    end

    @game_teams = CSV.read(game_teams_path, headers: true, header_converters: :symbol).map do |row|
      GameTeam.new(row.to_h)
    end
  end

  def total_goals_in_game
    @games.map do |game|
      game.away_goals + game.home_goals
    end
  end

  def count_of_games_by_season
    games_by_season = Hash.new(0)
    @games.each do |game|
      games_by_season[game.season_id] += 1
    end
    games_by_season
  end

  def count_of_goals_by_season
    goals_by_season = Hash.new(0)
    @games.each do |game|
      goals_by_season[game.season_id] += game.away_goals + game.home_goals
    end
    goals_by_season
  end

  def average_goals_per_game
    (total_goals_in_game.sum / @games.count.to_f).round(2)
  end

  def average_goals_by_season
    average_goals = {}
    count_of_goals_by_season.each do |season, goals|
      average_goals[season] = (goals.to_f / count_of_games_by_season[season]).round(2)
    end
    average_goals
  end

  def team_goals(home_or_away)
    team_goals = Hash.new { |hash, key| hash[key] = [] }
    @game_teams.each do |game_team|
      if game_team.home_or_away == home_or_away
        team_goals[game_team.team_id] << game_team.goals.to_i
      end
    end
    team_goals
  end

  def average_goals(team_goals)
    team_average = {}
    team_goals.each do |team_id, goals_per_game|
      team_average[team_id] = (goals_per_game.sum.to_f / goals_per_game.size.to_f).round(3)
    end
    team_average
  end

  def team_goal_average(home_or_away)
    team_goals = team_goals(home_or_away)
    average_goals(team_goals)
  end

  def find_team_name(team_element)
    team = @teams.find { |team| team.team_id == team_element[0] }
    team&.team_name
  end
  

  def highest_scoring_visitor_team
    highest_scoring = team_goal_average('away').max_by { |team_id, average_goals| average_goals }
    find_team_name(highest_scoring)
  end

  def lowest_scoring_visitor_team
    lowest_scoring = team_goal_average('away').min_by { |team_id, average_goals| average_goals }
    find_team_name(lowest_scoring)
  end

  
  # def season_data(all_seasons)
  #   @all_seasons = @games.map { |game| game.season_id }.uniq
  #   @season_data = {}
  
  #   @all_seasons.each do |season_id|
  #     season = @game_teams.select { |game_team| game_team.game_id[0, 4] == season_id[0, 4] }
  #     @season_data[season_id[0, 4]] = season
  #   end
  
  #   @season_data
  # end

  def season_data(all_seasons)
        all_seasons = @games.map { |game| game.season_id }.uniq
        @season_data = {}
        season = []
        @game_teams.select do |game_team|
          all_seasons.select do |season_id|
            if season_id[0,4] == game_team.game_id[0,4]
              season << game_team
              season_data[season_id[0,4]] = season
            end
          end
        end
        @season_data
      end
  
  def team_accuracy(season)
    season_data= season_data(@all_seasons) 
    season = season_data[season]
    
  
    season_goals = Hash.new(0)
    team_shots = Hash.new(0)
  
    season_data.each do |game_team_season|
      season_goals[game_team_season.team_id] += game_team_season.goals.to_i
      team_shots[game_team_season.team_id] += game_team_season.shots.to_i
    end
  
    team_accuracy = {}
    season_goals.each do |team_id, goals|
      shots = team_shots[team_id]
      if shots.zero?
        team_accuracy[team_id] = 0.0
      else
        accuracy = (goals.fdiv(shots) * 100).round(4)
        team_accuracy[team_id] = accuracy
      end
    end
  
    team_accuracy
  end

  def most_accurate_team(season)
        find_team_name(team_accuracy(season).max_by { |team_id,percent_accuracy| percent_accuracy })
      end
      def least_accurate_team(season)
        find_team_name(team_accuracy(season).min_by { |team_id,percent_accuracy| percent_accuracy })
      end
    end
  
#   def most_accurate_team(season)
#     team_accuracy = team_accuracy(season)
  
#     team_id = team_accuracy.max_by { |_, percent_accuracy| percent_accuracy }.first
#     find_team_name(team_id)
#   end
  
#   def least_accurate_team(season)
#     team_accuracy = team_accuracy(season)
  
#     team_id = team_accuracy.min_by { |_, percent_accuracy| percent_accuracy }.first
#     find_team_name(team_id)
#   end
# end 


# ef count_of_games_by_season
#     games_by_season = {}
#     @games.each do |game|
#       if games_by_season.include?(game.season_id)
#         games_by_season[game.season_id] += 1
#       else
#         games_by_season[game.season_id] = 1
#       end
#     end
#     games_by_season
#   end
#   def count_of_goals_by_season
#     goals_by_season = {}
#     @games.each do |game|
#       if goals_by_season.include?(game.season_id)
#         goals_by_season[game.season_id] += ([game.away_goals.to_f]+[game.away_goals.to_f])
#       elsif !goals_by_season.include?(game.season_id)
#         goals_by_season[game.season_id] = ([game.away_goals.to_f]+[game.home_goals.to_f])
#       end
#     goals_by_season
#     end
#   end
#   def average_goals_per_game
#     (total_goals_in_game.sum / @games.count.to_f).round(2)
#   end
#   def average_goals_by_season
#     average_goals = {}
#     count_of_goals_by_season.each do|season, goals|
#       count_of_games_by_season.each do|season_id, games|
#         if season_id == season
#         average_goals[season_id] = (goals/games).round(2)
#         end
#       end
#     end
#     average_goals
#   end
#   def team_goals(home_or_away)
#     team_goals = {}
#     @game_teams.each do |game_team|
#       if team_goals[game_team.team_id] != nil && game_team.home_or_away == home_or_away
#         team_goals[game_team.team_id].push(game_team.goals.to_i)
#       elsif  game_team.home_or_away == home_or_away
#         team_goals[game_team.team_id] = [game_team.goals.to_i]
#       end
#     end
#     team_goals
#   end
#   def average_goals(team_goals)
#     team_average = {}
#     team_goals.each do |team_id, goals_per_game|
#       team_average[team_id] = (goals_per_game.sum.to_f / goals_per_game.size.to_f).round(3)
#     end
#     team_average
#   end
#   def team_goal_average(home_or_away)
#       team_goals = team_goals(home_or_away)
#       average_goals(team_goals)
#     end
#   end
#   def find_team_name(team_element)
#     @teams.each do |team|
#       if team_element[0] == team.team_id
#         team_name = team.team_name
#       end
#     end
#   end
#   def highest_scoring_visitor_team
#     highest_scoring = team_goal_average('away').max_by{ |team_id, average_goals| average_goals }
#     find_team_name(highest_scoring)
#   end
#   def lowest_scoring_visitor_team
#     lowest_scoring = team_goal_average('away').min_by{ |id, average| average }
#   find_team_name(lowest_scoring)
#   end
#   # SEASON STATS
#   def season_data(all_seasons)
#     all_seasons = @games.map { |game| game[:season] }.uniq
#     @season_data = {}
#     season = []
#     @game_teams.select do |game_team|
#       all_seasons.select do |season_id|
#         if season_id[0,4] == game_team.game_id[0,4]
#           season << game_team
#           season_data[season_id[0,4]] = season
#         end
#       end
#     end
#     @season_data
#   end
#   def team_accuracy(season)
#     season_goals = {}
#     team_shots = {}
#     game_team_season = @season_data[season]
#       season_goals[game_team_season.team_id] += game_team_season.goals.to_i
#       team_shots[game_team_season.team_id] += game_team_season.shots.to_i
#     team_accuracy = {}
#     team_accuracy.update(season_goals,team_shots) do |team,goals,shots|
#       goals.fdiv(shots).round(4)*100
#     team_accuracy
#   end
#   def most_accurate_team(season)
#     find_team_name(team_accuracy(season).max_by { |team_id,percent_accuracy| percent_accuracy })
#   end
#   def least_accurate_team(season)
#     find_team_name(team_accuracy(season).min_by { |team_id,percent_accuracy| percent_accuracy })
#   end








