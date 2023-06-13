require 'rspec'
require 'csv'
require './lib/game.rb'
require './lib/team.rb'
require './lib/game_team.rb'
require './lib/stat_tracker.rb'

RSpec.describe StatTracker do
  let(:games_path) { './data/games.csv' }
  let(:teams_path) { '/data/teams.csv' }
  let(:game_teams_path) { './data/game_teams.csv' }

  let(:games_data) do
    [
      { game_id: '1', season: '20182019', type: 'Regular Season', date_time: '2018-10-03',
        away_team_id: '3', home_team_id: '6', away_goals: '2', home_goals: '5',
        venue: 'Arena 1', venue_link: 'arena1.com' },
      { game_id: '2', season: '20182019', type: 'Regular Season', date_time: '2018-10-04',
        away_team_id: '4', home_team_id: '6', away_goals: '3', home_goals: '4',
        venue: 'Arena 2', venue_link: 'arena2.com' }
    ]
  end

  let(:teams_data) do
    [
      { team_id: '3', franchiseid: '10', teamname: 'Team 1', abbreviation: 'T1',
        stadium: 'Stadium 1', link: 'team1.com' },
      { team_id: '4', franchiseid: '11', teamname: 'Team 2', abbreviation: 'T2',
        stadium: 'Stadium 2', link: 'team2.com' },
      { team_id: '6', franchiseid: '13', teamname: 'Team 3', abbreviation: 'T3',
        stadium: 'Stadium 3', link: 'team3.com' }
    ]
  end

  let(:game_teams_data) do
    [
      { game_id: '1', team_id: '3', hoa: 'away', result: 'loss', settled_in: 'regulation',
        head_coach: 'Coach 1', goals: '2', shots: '30', tackles: '10', pim: '4',
        powerplayopportunities: '4', powerplaygoals: '1', faceoffwinpercentage: '50.0',
        giveaways: '5', takeaways: '2' },
      { game_id: '1', team_id: '6', hoa: 'home', result: 'win', settled_in: 'regulation',
        head_coach: 'Coach 2', goals: '5', shots: '40', tackles: '12', pim: '6',
        powerplayopportunities: '3', powerplaygoals: '1', faceoffwinpercentage: '55.0',
        giveaways: '3', takeaways: '4' },
      { game_id: '2', team_id: '4', hoa: 'away', result: 'win', settled_in: 'regulation',
        head_coach: 'Coach 3', goals: '3', shots: '35', tackles: '8', pim: '3',
        powerplayopportunities: '5', powerplaygoals: '2', faceoffwinpercentage: '52.5',
        giveaways: '4', takeaways: '3' },
      { game_id: '2', team_id: '6', hoa: 'home', result: 'loss', settled_in: 'regulation',
        head_coach: 'Coach 2', goals: '4', shots: '38', tackles: '10', pim: '5',
        powerplayopportunities: '2', powerplaygoals: '1', faceoffwinpercentage: '51.0',
        giveaways: '2', takeaways: '5' }
    ]
  end

  let(:locations) do
    {
      games: games_path,
      teams: teams_path,
      game_teams: game_teams_path
    }
  end

  before do
    allow(CSV).to receive(:read).with(games_path, headers: true, header_converters: :symbol)
                                 .and_return(games_data)
    allow(CSV).to receive(:read).with(teams_path, headers: true, header_converters: :symbol)
                                 .and_return(teams_data)
    allow(CSV).to receive(:read).with(game_teams_path, headers: true, header_converters: :symbol)
                                 .and_return(game_teams_data)
  end

  subject(:stat_tracker) { described_class.new(locations) }

  describe 'initialize' do
    it 'imports games, teams, and game_teams data' do
      expect(stat_tracker.games.size).to eq(2)
      expect(stat_tracker.teams.size).to eq(3)
      expect(stat_tracker.game_teams.size).to eq(4)
    end
  end

  describe 'total_goals_in_game' do
    it 'returns an array of total goals in each game' do
      expect(stat_tracker.total_goals_in_game).to eq([7, 7])
    end
  end

  describe 'count_of_games_by_season' do
    it 'returns a hash with the count of games by season' do
      expect(stat_tracker.count_of_games_by_season).to eq({ '20182019' => 2 })
    end
  end

  describe 'count_of_goals_by_season' do
    it 'returns a hash with the count of goals by season' do
      expect(stat_tracker.count_of_goals_by_season).to eq({ '20182019' => 14 })
    end
  end

  describe 'average_goals_per_game' do
    it 'returns the average goals per game' do
      expect(stat_tracker.average_goals_per_game).to eq(7.0)
    end
  end

  describe 'average_goals_by_season' do
    it 'returns a hash with the average goals per game by season' do
      expect(stat_tracker.average_goals_by_season).to eq({ '20182019' => 7.0 })
    end
  end

  describe 'highest_scoring_visitor_team' do
    it 'returns the name of the highest scoring visitor team' do
      expect(stat_tracker.highest_scoring_visitor_team).to eq('Team 2')
    end
  end

  describe 'lowest_scoring_visitor_team' do
    it 'returns the name of the lowest scoring visitor team' do
      expect(stat_tracker.lowest_scoring_visitor_team).to eq('Team 1')
    end
  end

  describe 'most_accurate_team' do
    it 'returns the name of the most accurate team in a given season' do
      expect(stat_tracker.most_accurate_team('20182019')).to eq('Team 3')
    end
  end

  describe 'least_accurate_team' do
    it 'returns the name of the least accurate team in a given season' do
      expect(stat_tracker.least_accurate_team('20182019')).to eq('Team 1')
    end
  end
end
