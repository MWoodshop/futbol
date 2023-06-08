class Game
  attr_reader :game_id,
              :season_id,
              :season_type,
              :game_date,
              :away_team_id,
              :home_team_id,
              :away_team_goals,
              :home_team_goals,
              :venue_name,
              :venue_link

  def initialize(attributes)
    @game_id = attributes[:game_id]
    @season_id = attributes[:season]
    @season_type = attributes[:type]
    @game_date = attributes[:date_time]
    @away_team_id = attributes[:away_team_id]
    @home_team_id = attributes[:home_team_id]
    @away_team_goals = attributes[:away_goals]
    @home_team_goals = attributes[:home_goals]
    @venue_name = attributes[:venue]
    @venue_link = attributes[:venue_link]
  end

  def home_win?
    home_team_goals > away_team_goals
  end

  def visitor_win?
    away_team_goals > home_team_goals
  end
end
