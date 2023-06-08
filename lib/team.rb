class Team
  attr_reader :team_id,
              :franchise_id,
              :team_name,
              :team_abbreviation,
              :team_stadium_name,
              :team_api_url

  def initialize(attributes)
    @team_id = attributes[:team_id]
    @franchise_id = attributes[:franchiseId]
    @team_name = attributes[:teamName]
    @team_abbreviation = attributes[:abbreviation]
    @team_stadium_name = attributes[:Stadium]
    @team_api_url = attributes[:link]
  end
end
