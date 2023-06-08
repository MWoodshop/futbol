class Season
  attr_reader :season_id, :games

  def initialize(season_id, games)
    @season_id = season_id
    @games = games
  end
end
