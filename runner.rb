require './lib/stat_tracker'

# Instantiate the StatTracker using the from_csv method
data_paths = {
  games: './data/games.csv',
  teams: './data/teams.csv',
  game_teams: './data/game_teams.csv'
}
stat_tracker = StatTracker.from_csv(data_paths)
puts ''
# First 2 result of the initial data after it has been loaded
puts 'Games:'
stat_tracker.games.first(2).each do |game|
  puts game.inspect
end

puts "\nTeams:"
stat_tracker.teams.first(2).each do |team|
  puts team.inspect
end

puts "\nGame Teams:"
stat_tracker.game_teams.first(2).each do |game_team|
  puts game_team.inspect
end

puts ''
# Example of methods in StatTracker being called
puts "Total number of games: #{stat_tracker.games.count}"
puts "Total number of teams: #{stat_tracker.teams.count}"
puts "Highest total score: #{stat_tracker.highest_total_score}"

# Example of calling a specific method to get statistics
average_goals = stat_tracker.average_goals_per_game
puts "Average goals per game: #{average_goals}"

puts ''
