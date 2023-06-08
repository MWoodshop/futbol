require 'spec_helper'

RSpec.describe Game do
  before :each do
    # Creates stubbed data of seven games to test against
    allow(File).to receive(:read).and_return("game_id,season,date_time,away_team_id,home_team_id,away_goals,home_goals,venue,venue_link\n1,2012030221,2012-05-16,3,6,2,3,TD Garden,/api/v1/venues/null\n2,2012030222,2012-05-19,3,6,3,2,TD Garden,/api/v1/venues/null\n3,2012030223,2012-05-21,6,3,2,3,TD Garden,/api/v1/venues/null")
    @game = Game.new
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@game).to be_a(Game)
    end

    it 'returns number of games' do
      expect(@game.games.count).to eq(3)
    end
  end

  describe '#percentage_home_wins' do
    it 'returns a float' do
      expect(@game.percentage_home_wins).to eq(66.67)
    end
  end
end
