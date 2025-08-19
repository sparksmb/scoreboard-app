# Forney 2025 Schedule - Texas High School Football Teams
# This seed file creates teams based on the Forney Jackrabbits 2025 schedule

# Ensure we have an organization to work with
organization = Organization.find_or_create_by(name: "FHS Broadcast Team")

# Define team data from the schedule
teams_data = [
  {
    name: "Forney Jackrabbits",
    mascot: "Jackrabbits",
    city: "Forney",
    state: "TX",
    primary_color: "#000080", # Navy Blue
    secondary_color: "#FFD700", # Gold
    logo_search_terms: "Forney High School Jackrabbits logo"
  },
  {
    name: "Rowlett Eagles",
    mascot: "Eagles",
    city: "Rowlett",
    state: "TX", 
    primary_color: "#8B0000", # Dark Red
    secondary_color: "#FFFFFF", # White
    logo_search_terms: "Rowlett High School Eagles logo"
  },
  {
    name: "Lake Highlands Wildcats",
    mascot: "Wildcats",
    city: "Dallas", # Lake Highlands is part of Dallas
    state: "TX",
    primary_color: "#000080", # Navy Blue
    secondary_color: "#FFD700", # Gold
    logo_search_terms: "Lake Highlands High School Wildcats logo Dallas"
  },
  {
    name: "A&M Consolidated Tigers",
    mascot: "Tigers",
    city: "College Station",
    state: "TX",
    primary_color: "#500000", # Maroon
    secondary_color: "#FFFFFF", # White
    logo_search_terms: "A&M Consolidated High School Tigers logo College Station"
  },
  {
    name: "Waxahachie Indians",
    mascot: "Indians",
    city: "Waxahachie",
    state: "TX",
    primary_color: "#8B0000", # Dark Red
    secondary_color: "#000000", # Black
    logo_search_terms: "Waxahachie High School Indians logo"
  },
  {
    name: "Boswell Pioneers",
    mascot: "Pioneers", 
    city: "Fort Worth", # Boswell is part of Fort Worth area
    state: "TX",
    primary_color: "#000080", # Navy Blue
    secondary_color: "#C0C0C0", # Silver
    logo_search_terms: "Boswell High School Pioneers logo Fort Worth"
  },
  {
    name: "North Forney Falcons",
    mascot: "Falcons",
    city: "Forney",
    state: "TX",
    primary_color: "#8B0000", # Dark Red
    secondary_color: "#000000", # Black
    logo_search_terms: "North Forney High School Falcons logo"
  },
  {
    name: "Royse City Bulldogs",
    mascot: "Bulldogs", 
    city: "Royse City",
    state: "TX",
    primary_color: "#000080", # Navy Blue
    secondary_color: "#FFD700", # Gold
    logo_search_terms: "Royse City High School Bulldogs logo"
  },
  {
    name: "Longview Lobos",
    mascot: "Lobos",
    city: "Longview",
    state: "TX",
    primary_color: "#FFFFFF", # White
    secondary_color: "#000080", # Navy Blue
    logo_search_terms: "Longview High School Lobos logo"
  },
  {
    name: "Rockwall Yellowjackets",
    mascot: "Yellowjackets",
    city: "Rockwall", 
    state: "TX",
    primary_color: "#FFD700", # Gold
    secondary_color: "#000000", # Black
    logo_search_terms: "Rockwall High School Yellowjackets logo"
  },
  {
    name: "Tyler Legacy Red Raiders",
    mascot: "Red Raiders",
    city: "Tyler",
    state: "TX",
    primary_color: "#8B0000", # Dark Red
    secondary_color: "#000000", # Black
    logo_search_terms: "Tyler Legacy High School Red Raiders logo"
  },
  {
    name: "Rockwall Heath Hawks",
    mascot: "Hawks",
    city: "Rockwall",
    state: "TX",
    primary_color: "#000080", # Navy Blue
    secondary_color: "#C0C0C0", # Silver
    logo_search_terms: "Rockwall Heath High School Hawks logo"
  }
]

puts "Creating Texas High School Football Teams from Forney 2025 Schedule..."

teams_data.each do |team_data|
  team = Team.find_or_create_by(
    name: team_data[:name],
    organization: organization
  ) do |t|
    t.mascot = team_data[:mascot]
    t.primary_color = team_data[:primary_color]
    t.secondary_color = team_data[:secondary_color]
  end
  
  if team.persisted?
    puts "✓ Created/Found team: #{team.name} (#{team.mascot}) from #{team_data[:city]}, #{team_data[:state]}"
    puts "  Colors: #{team.primary_color} / #{team.secondary_color}"
    puts "  Logo search: #{team_data[:logo_search_terms]}"
  else
    puts "✗ Failed to create team: #{team_data[:name]} - #{team.errors.full_messages.join(', ')}"
  end
  puts
end

# Create sample games based on the 2025 schedule
games_data = [
  { home_team: "Forney Jackrabbits", visitor_team: "Rowlett Eagles", date: "2025-08-29", location: "Forney High School" },
  { home_team: "Lake Highlands Wildcats", visitor_team: "Forney Jackrabbits", date: "2025-08-28", location: "Lake Highlands High School" },
  { home_team: "A&M Consolidated Tigers", visitor_team: "Forney Jackrabbits", date: "2025-09-05", location: "A&M Consolidated High School" },
  { home_team: "Forney Jackrabbits", visitor_team: "Waxahachie Indians", date: "2025-09-12", location: "Forney High School" },
  { home_team: "Boswell Pioneers", visitor_team: "Forney Jackrabbits", date: "2025-09-19", location: "Boswell High School" },
  { home_team: "Forney Jackrabbits", visitor_team: "North Forney Falcons", date: "2025-09-26", location: "Forney High School" },
  { home_team: "Royse City Bulldogs", visitor_team: "Forney Jackrabbits", date: "2025-10-03", location: "Royse City High School" },
  { home_team: "Forney Jackrabbits", visitor_team: "Longview Lobos", date: "2025-10-10", location: "Forney High School" },
  { home_team: "Rockwall Yellowjackets", visitor_team: "Forney Jackrabbits", date: "2025-10-17", location: "Rockwall High School" },
  { home_team: "Forney Jackrabbits", visitor_team: "Tyler Legacy Red Raiders", date: "2025-10-31", location: "Forney High School" },
  { home_team: "Rockwall Heath Hawks", visitor_team: "Forney Jackrabbits", date: "2025-11-06", location: "Rockwall Heath High School" }
]

puts "Creating games from Forney 2025 schedule..."

games_data.each do |game_data|
  home_team = Team.find_by(name: game_data[:home_team], organization: organization)
  visitor_team = Team.find_by(name: game_data[:visitor_team], organization: organization)
  
  if home_team && visitor_team
    game = Game.find_or_create_by(
      organization: organization,
      home_team: home_team,
      visitor_team: visitor_team,
      game_date: Date.parse(game_data[:date])
    ) do |g|
      g.location = game_data[:location]
    end
    
    if game.persisted?
      puts "✓ Created/Found game: #{home_team.name} vs #{visitor_team.name} on #{game_data[:date]}"
    else
      puts "✗ Failed to create game: #{game.errors.full_messages.join(', ')}"
    end
  else
    puts "✗ Could not find teams for game: #{game_data[:home_team]} vs #{game_data[:visitor_team]}"
  end
end

puts "\n🏈 Forney 2025 Schedule Teams and Games Created!"
puts "Organization: #{organization.name}"
puts "Teams created: #{organization.teams.count}"
puts "Games created: #{organization.games.count}"
