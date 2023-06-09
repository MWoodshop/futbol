require 'spec_helper'


describe StatTracker do
  before( :each) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  it "exists" do
    expect(@stat_tracker).to be_a StatTracker
  end

  it "can calculate percentage ties" do
    expect(@stat_tracker.percentage_ties).to eq(0.20)
  end

  it "can count games by season" do
    expect(@stat_tracker.count_of_games_by_season).to eq({
      "20122013" => 806,
      "20162017" => 1317,
      "20142015" => 1319,
      "20152016" => 1321,
      "20132014" => 1323,
      "20172018" => 1355
    })
  end

end