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

 

  def count_of_games_by_season
    games_by_season = {}
    @games.each do |game|
    
      if games_by_season.include?(game.season_id)
        games_by_season[game.season_id] += 1 
      else
        games_by_season[game.season_id] = 1 
      end
    end
    games_by_season
   
  end

  def count_of_goals_by_season
    goals_by_season = {}
    @games.each do |game|
      if goals_by_season.include?(game.season_id)
        goals_by_season[game.season_id] += ([game.away_goals.to_f]+[game.away_goals.to_f])
      elsif !goals_by_season.include?(game.season_id)
        goals_by_season[game.season_id] = ([game.away_goals.to_f]+[game.home_goals.to_f])
      end 
    goals_by_season
    end
  end

  def average_goals_per_game
    (total_goals_in_game.sum / @games.count.to_f).round(2)
  end

  def average_goals_by_season
    average_goals = {}  
    count_of_goals_by_season.each do|season, goals|
      count_of_games_by_season.each do|season_id, games|
        if season_id == season
        average_goals[season_id] = (goals/games).round(2) 
        end
      end
    end
    average_goals
  end

  def percentage_ties
    tie_games = @game_teams.find_all do |game|
      game.game_result.include?("TIE")
    end
    results = tie_games.length.to_f / @game_teams.length.to_f
    results.round(2)
  end

  def count_of_games_by_season
    ids = []
    only_ids = []
      @games.find_all do |game|
        ids = game.season_id
        only_ids << ids
      end
    uniq_ids = only_ids.uniq
    count_games = []
    final_count = Hash.new
      uniq_ids.each do |id|
        count_games = @games.find_all {|game|game.season_id.include?(id)}
        final_count[id] = count_games.length
      end
      final_count
  end

  # LEAGUE STATS

  def highest_scoring_home_team
    game_team_goals = Hash.new
    @game_teams.each do |game_team|
      game_team_goals[game_team.team_id.to_sym] = []
    end
    @game_teams.each do |game_team|
      goal_array = game_team_goals[game_team.team_id.to_sym]
        if game_team.home_or_away == "home"
          goal_array << game_team.goals.to_i
        end
    end
    game_team_goals.map do |team, goal_array|
      game_team_goals[team] = (goal_array.sum.to_f / goal_array.length.to_f)
    end
    max_key_value = game_team_goals.max_by{ |team, goals| goals }
  
    team = @teams.find do |team|
      max_key_value[0].to_s == team.team_id
    end
    team.team_name
  end
  
  def lowest_scoring_home_team
    game_team_goals = Hash.new
    @game_teams.each do |game_team|
      game_team_goals[game_team.team_id.to_sym] = []
    end
    @game_teams.each do |game_team|
      goal_array = game_team_goals[game_team.team_id.to_sym]
        if game_team.home_or_away == "home"
          goal_array << game_team.goals.to_i
        end
    end
    game_team_goals.map do |team, goal_array|
      game_team_goals[team] = (goal_array.sum.to_f / goal_array.length.to_f)
    end
    min_key_value = game_team_goals.min_by{ |team, goals| goals }
    team = @teams.find do |team|
      min_key_value[0].to_s == team.team_id
    end
    team.team_name
  end

  # SEASON STATS

  def winningest_coach(season_id)
    season_games = @games.select { |game| game.season_id == season_id }
    season_game_ids = season_games.map(&:game_id)

  def team_goals(home_or_away)
    team_goals = {}
    @game_teams.each do |game_team|
      if team_goals[game_team.team_id] != nil && game_team.home_or_away == home_or_away
        team_goals[game_team.team_id].push(game_team.goals.to_i)
      elsif  game_team.home_or_away == home_or_away
        team_goals[game_team.team_id] = [game_team.goals.to_i]
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
  end

  def find_team_name(team_element)
    @teams.each do |team|
      if team_element[0] == team.team_id
        team_name = team.team_name
      end
    end
  end

  def highest_scoring_visitor_team
    highest_scoring = team_goal_average('away').max_by{ |team_id, average_goals| average_goals }
    find_team_name(highest_scoring)
  end


  def lowest_scoring_visitor_team
    lowest_scoring = team_goal_average('away').min_by{ |id, average| average }
  find_team_name(lowest_scoring)
  end

  # SEASON STATS
 
  def season_data(all_seasons)
    all_seasons = @games.map { |game| game[:season] }.uniq
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
  
  def fewest_tackles(season)
    season_games = @games.find_all do |game|
      game.season_id == season
    end
    season_game_ids = season_games.map do |game|
      game.game_id
    end
    game_team_array = []
    @game_teams.each do |game_team|
      if season_game_ids.include?(game_team.game_id)
        game_team_array <<  game_team
      end
    end
    season_game_tackles = Hash.new
    game_team_array.each do |game_team|
      season_game_tackles[game_team.team_id.to_sym] = []
    end
    game_team_array.each do |game_team|
      tackles_array = season_game_tackles[game_team.team_id.to_sym]
      tackles_array << game_team.tackles.to_i
    end
    season_game_tackles.map do |team, goal_array|
      season_game_tackles[team] = goal_array.sum
    end
    min_key_value = season_game_tackles.min_by{ |team, tackles| tackles }
    team = @teams.find do |team|
      min_key_value[0].to_s == team.team_id
    end
    team.team_name
  end

  def team_accuracy(season)
    season_goals = {}
    team_shots = {}

    game_team_season = @season_data[season]
      season_goals[game_team_season.team_id] += game_team_season.goals.to_i
      team_shots[game_team_season.team_id] += game_team_season.shots.to_i
    
    team_accuracy = {}

    team_accuracy.update(season_goals,team_shots) do |team,goals,shots|
      goals.fdiv(shots).round(4)*100
   
    team_accuracy
  end

  def most_accurate_team(season)
    find_team_name(team_accuracy(season).max_by { |team_id,percent_accuracy| percent_accuracy })
  end

  def least_accurate_team(season)
    find_team_name(team_accuracy(season).min_by { |team_id,percent_accuracy| percent_accuracy })
  end
end












