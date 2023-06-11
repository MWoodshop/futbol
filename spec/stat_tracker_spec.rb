require 'spec_helper'

# IMPORTANT
# ___________________________
# !!! THIS IS OUR SPEC VERSION OF THIS FILE, NOT THE SPEC HARNESS VERSION !!!#
# ___________________________

describe StatTracker do
  let(:game_data) do
    [
      { game_id: '2012030221', season: '20122013', type: 'Postseason', date_time: '5/16/13', away_team_id: '3',
        home_team_id: '6', away_goals: 2, home_goals: 3, venue: 'Toyota Stadium', venue_link: '/api/v1/venues/null' },
      { game_id: '2012030222', season: '20122013', type: 'Postseason', date_time: '5/19/13', away_team_id: '3',
        home_team_id: '6', away_goals: 2, home_goals: 3, venue: 'Toyota Stadium', venue_link: '/api/v1/venues/null' },
      { game_id: '2012030223', season: '20122013', type: 'Postseason', date_time: '5/21/13', away_team_id: '6',
        home_team_id: '3', away_goals: 2, home_goals: 1, venue: 'BBVA Stadium', venue_link: '/api/v1/venues/null' },
      { game_id: '2012030224', season: '20122013', type: 'Postseason', date_time: '5/23/13', away_team_id: '6',
        home_team_id: '3', away_goals: 3, home_goals: 2, venue: 'BBVA Stadium', venue_link: '/api/v1/venues/null' }
    ]
  end

  let(:team_data) do
    [
      { team_id: 6, franchiseId: 6, teamName: 'FC Dallas', abbreviation: 'DAL', Stadium: 'Toyota Stadium',
        link: '/api/v1/teams/6' },
      { team_id: 3, franchiseId: 10, teamName: 'Houston Dynamo', abbreviation: 'HOU', Stadium: 'BBVA Stadium',
        link: '/api/v1/teams/3' }
    ]
  end

  let(:game_team_data) do
    [
      { game_id: '2012030221', team_id: 3, HoA: 'away', result: 'LOSS', settled_in: 'OT', head_coach: 'John Tortorella', goals: 2, shots: 8, tackles: 44, pim: 8, powerPlayOpportunities: 3, powerPlayGoals: 0, faceOffWinPercentage: 44.8, giveaways: 17, takeaways: 7 }, { game_id: '1', team_id: '2', coach: 'Coach B', game_result: 'LOSS' },
      { game_id: '2012030221', team_id: 6, HoA: 'home', result: 'WIN', settled_in: 'OT', head_coach: 'Claude Julien', goals: 3, shots: 12, tackles: 51, pim: 6, powerPlayOpportunities: 4, powerPlayGoals: 1, faceOffWinPercentage: 55.2, giveaways: 4, takeaways: 5 }, { game_id: '2', team_id: '2', coach: 'Coach B', game_result: 'WIN' },
      { game_id: '2012030222', team_id: 3, HoA: 'away', result: 'LOSS', settled_in: 'REG', head_coach: 'John Tortorella', goals: 2, shots: 9, tackles: 33, pim: 11, powerPlayOpportunities: 5, powerPlayGoals: 0, faceOffWinPercentage: 51.7, giveaways: 1, takeaways: 4 },
      { game_id: '2012030222', team_id: 6, HoA: 'home', result: 'WIN', settled_in: 'REG', head_coach: 'Claude Julien', goals: 3, shots: 8, tackles: 36, pim: 19, powerPlayOpportunities: 1, powerPlayGoals: 0, faceOffWinPercentage: 48.3, giveaways: 16, takeaways: 6 },
      { game_id: '2012030223', team_id: 6, HoA: 'away', result: 'WIN', settled_in: 'REG', head_coach: 'Claude Julien', goals: 2, shots: 8, tackles: 28, pim: 6, powerPlayOpportunities: 0, powerPlayGoals: 0, faceOffWinPercentage: 61.8, giveaways: 10, takeaways: 7 },
      { game_id: '2012030223', team_id: 3, HoA: 'home', result: 'LOSS', settled_in: 'REG', head_coach: 'John Tortorella', goals: 1, shots: 6, tackles: 37, pim: 2, powerPlayOpportunities: 2, powerPlayGoals: 0, faceOffWinPercentage: 38.2, giveaways: 7, takeaways: 9 },
      { game_id: '2012030224', team_id: 6, HoA: 'away', result: 'WIN', settled_in: 'OT', head_coach: 'Claude Julien', goals: 3, shots: 10, tackles: 24, pim: 8, powerPlayOpportunities: 4, powerPlayGoals: 2, faceOffWinPercentage: 53.7, giveaways: 8, takeaways: 6 },
      { game_id: '2012030224', team_id: 3, HoA: 'home', result: 'LOSS', settled_in: 'OT', head_coach: 'John Tortorella', goals: 2, shots: 8, tackles: 40, pim: 8, powerPlayOpportunities: 4, powerPlayGoals: 1, faceOffWinPercentage: 46.3, giveaways: 9, takeaways: 7 }
    ]
  end

  before do
    allow(CSV).to receive(:read).with(any_args).and_return([]) # Stub CSV.read to return an empty array
    allow(CSV).to receive(:read).with('path/to/games.csv', headers: true,
                                                           header_converters: :symbol).and_return(game_data)
    allow(CSV).to receive(:read).with('path/to/teams.csv', headers: true,
                                                           header_converters: :symbol).and_return(team_data)
    allow(CSV).to receive(:read).with('path/to/game_teams.csv', headers: true,
                                                                header_converters: :symbol).and_return(game_team_data)

    @locations = {
      games: 'path/to/games.csv',
      teams: 'path/to/teams.csv',
      game_teams: 'path/to/game_teams.csv'
    }
    @stat_tracker = StatTracker.new(@locations)
  end

  it 'exists' do
    expect(@stat_tracker).to be_an_instance_of(StatTracker)
  end

  it 'has attributes' do
  end
  it '#percentage_home_wins' do
    expect(@stat_tracker.percentage_home_wins).to eq 0.5
  end

  it '#percentage_visitor_wins' do
    expect(@stat_tracker.percentage_visitor_wins).to eq 0.5
  end

  it '#count_of_teams' do
    expect(@stat_tracker.count_of_teams).to eq 2
  end

  it '#winningest_coach' do
    expect(@stat_tracker.winningest_coach('20122013')).to eq 'Claude Julien'
  end

  it '#worst_coach' do
    expect(@stat_tracker.worst_coach('20122013')).to eq 'John Tortorella'
  end
end
