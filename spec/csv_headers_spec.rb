require 'spec_helper'

RSpec.describe CSVHeaders do
  describe '.get_headers' do
    it 'returns headers of the csv file' do
      file_path = './data/games.csv'

      allow(File).to receive(:exist?).with(file_path).and_return(true)
      allow(CSV).to receive(:open).with(file_path, 'r').and_yield([
        'game_id,season,date_time,away_team_id,home_team_id,away_goals,home_goals,venue,venue_link',
        '1,2012030221,2012-05-16,3,6,2,3,TD Garden,/api/v1/venues/null',
        '2,2012030222,2012-05-19,3,6,3,2,TD Garden,/api/v1/venues/null',
        '3,2012030223,2012-05-21,6,3,2,3,TD Garden,/api/v1/venues/null'
      ].map { |row| row.split(',') })

      headers = CSVHeaders.get_headers(file_path)

      expect(headers).to eq(%w[game_id season date_time away_team_id home_team_id away_goals home_goals
                               venue venue_link])
    end
  end
end
