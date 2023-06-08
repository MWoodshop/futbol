require 'spec_helper'

RSpec.describe Game do
  before do
    # Creates stubbed data to test against
    allow(File).to receive(:read).and_return("game_id,season,date_time,away_team_id,home_team_id,away_goals,home_goals,venue,venue_link\n1,2012030221,2012-05-16,3,6,2,3,TD Garden,/api/v1/venues/null\n2,2012030222,2012-05-19,3,6,2,2,TD Garden,/api/v1/venues/null\n")
  end

  describe '#initialize' do
    it 'can initialize' do
      game = Game.new

      expect(game).to be_a(Game)
    end

    it 'returns number of games' do
      game = Game.new

      expect(game.games.count).to eq(2)
    end
  end
end
