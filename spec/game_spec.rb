require 'spec_helper'

RSpec.describe Game do
  before do
    # Creates stubbed data of six games to test against
    allow(File).to receive(:read).and_return("game_id,season,date_time,away_team_id,home_team_id,away_goals,home_goals,venue,venue_link\n1,2012030221,2012-05-16,3,6,2,3,TD Garden,/api/v1/venues/null\n2,2012030222,2012-05-19,3,6,3,2,TD Garden,/api/v1/venues/null\n3,2012030223,2012-05-21,6,3,2,3,TD Garden,/api/v1/venues/null\n4,2012030224,2012-05-23,6,3,3,2,TD Garden,/api/v1/venues/null\n5,2012030225,2012-05-25,3,6,2,3,TD Garden,/api/v1/venues/null\n6,2012030226,2012-05-27,3,6,3,2,TD Garden,/api/v1/venues/null")
  end

  describe '#initialize' do
    it 'can initialize' do
      game = Game.new

      expect(game).to be_a(Game)
    end

    it 'returns number of games' do
      game = Game.new

      expect(game.games.count).to eq(6)
    end
  end
end
