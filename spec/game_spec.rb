require 'spec_helper'

RSpec.describe Game do
  before :each do
    file_name = './data/games.csv'
    @reader = Game.new(file_name)
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@reader.data).to include(['Value 1', 'Value 2', 'Value 3'])
    end
  end
end
