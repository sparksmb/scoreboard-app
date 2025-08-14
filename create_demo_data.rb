# Create demo data for live scoreboard testing

# Create an admin user
admin = User.find_or_create_by(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.admin = true
end

# Create an organization
org = Organization.find_or_create_by(name: 'Demo Sports Network')

# Create teams
home_team = Team.find_or_create_by(name: 'Home Hawks', organization: org) do |team|
  team.primary_color = '0066CC'
  team.secondary_color = 'FFFFFF'
end

visitor_team = Team.find_or_create_by(name: 'Visitor Vikings', organization: org) do |team|
  team.primary_color = 'CC0000'
  team.secondary_color = 'FFFFFF'
end

# Create a game for today
game = Game.find_or_create_by(
  organization: org,
  home_team: home_team,
  visitor_team: visitor_team,
  game_date: Date.current
) do |g|
  g.location = 'Demo Stadium'
  g.description = 'Championship Game'
end

# Create a football scoreboard
scoreboard = FootballScoreboard.find_or_create_by(game: game) do |sb|
  sb.home_score = 14
  sb.visitor_score = 10
  sb.home_timeouts_remaining = 3
  sb.visitor_timeouts_remaining = 2
  sb.quarter = 2
  sb.time_remaining = '08:45'
end

puts "Demo data created successfully!"
puts "Organization ID: #{org.id}"
puts "Game ID: #{game.id}"  
puts "Scoreboard ID: #{scoreboard.id}"
puts ""
puts "Live scoreboard URL: http://localhost:3000/organizations/#{org.id}/scoreboard"
puts ""
puts "You can now test the realtime updates by updating the scoreboard in Rails console:"
puts "  scoreboard = FootballScoreboard.find(#{scoreboard.id})"
puts "  scoreboard.update(home_score: 21, visitor_score: 17)"
