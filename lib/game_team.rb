class GameTeam
  attr_reader :game_id,
              :team_id,
              :home_or_away,
              :game_result,
              :game_end_reg_or_ot,
              :coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :power_play_opps,
              :power_play_goals,
              :face_off_win_percentage,
              :giveaways,
              :takeaways

  def initialize(attributes)
    @game_id = attributes[:game_id]
    @team_id = attributes[:team_id]
    @home_or_away = attributes[:HoA]
    @game_result = attributes[:result]
    @game_end_reg_or_ot = attributes[:settled_in]
    @coach = attributes[:head_coach]
    @goals = attributes[:goals]
    @shots = attributes[:shots]
    @tackles = attributes[:tackles]
    @pim = attributes[:pim]
    @power_play_opps = attributes[:powerPlayOpportunities]
    @power_play_goals = attributes[:powerPlayGoals]
    @face_off_win_percentage = attributes[:faceOffWinPercentage]
    @giveaways = attributes[:giveaways]
    @takeaways = attributes[:takeaways]
  end

  def win?
    @game_result == 'WIN'
  end
end
