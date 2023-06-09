class Season
  attr_reader :season_id, :games

  def initialize(season_id, games)
    @season_id = season_id
    @games = games
  end

  def winningest_coach
    coach_wins = Hash.new(0)

    @games.each do |game|
      if game.winner
        winning_coach = game.winner.coach
        coach_wins[winning_coach] += 1
      end
    end

    coach_wins.max_by { |_coach, wins| wins }.first
  end

  def worst_coach
    coach_wins = Hash.new(0)
    coach_games = Hash.new(0)

    @games.each do |game|
      game.game_teams.each do |game_team|
        coach_games[game_team.coach] += 1
        coach_wins[game_team.coach] += 1 if game_team.win?
      end
    end

    coach_win_percentages = {}
    coach_games.each do |coach, games|
      coach_win_percentages[coach] = coach_wins[coach].to_f / games * 100
    end

    coach_win_percentages.min_by { |_coach, win_percentage| win_percentage }.first
  end
end
