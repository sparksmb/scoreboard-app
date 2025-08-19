# Attach Logo Files to Teams
# Run this after you've downloaded logo files to app/assets/images/team_logos/

puts "🏈 Attaching Team Logo Files..."

# Define logo file mappings
logo_files = [
  { team_name: "A&M Consolidated Tigers", filename: "am_consolidated_tigers_logo.png" },
  { team_name: "Forney Jackrabbits", filename: "forney_jackrabbits_logo.png" },
  { team_name: "Lake Highlands Wildcats", filename: "lake_highlands_wildcats_logo.png" },
  { team_name: "Rowlett Eagles", filename: "rowlett_eagles_logo.png" },
  { team_name: "Waxahachie Indians", filename: "waxahachie_indians_logo.png" },
  { team_name: "Boswell Pioneers", filename: "boswell_pioneers_logo.png" },
  { team_name: "North Forney Falcons", filename: "north_forney_falcons_logo.png" },
  { team_name: "Royse City Bulldogs", filename: "royse_city_bulldogs_logo.png" },
  { team_name: "Longview Lobos", filename: "longview_lobos_logo.png" },
  { team_name: "Rockwall Yellowjackets", filename: "rockwall_yellowjackets_logo.png" },
  { team_name: "Tyler Legacy Red Raiders", filename: "tyler_legacy_red_raiders_logo.png" },
  { team_name: "Rockwall Heath Hawks", filename: "rockwall_heath_hawks_logo.png" }
]

organization = Organization.find_by(name: "Texas High School Football")
unless organization
  puts "❌ Organization 'Texas High School Football' not found. Run the team seed file first."
  exit
end

logos_dir = Rails.root.join('app', 'assets', 'images', 'team_logos')

logo_files.each do |logo_data|
  team = Team.find_by(name: logo_data[:team_name], organization: organization)
  
  if team
    logo_path = logos_dir.join(logo_data[:filename])
    
    if File.exist?(logo_path)
      # Attach the logo file
      team.logo.attach(
        io: File.open(logo_path),
        filename: logo_data[:filename],
        content_type: 'image/png'
      )
      
      if team.logo.attached?
        puts "✅ Attached logo for #{team.name}: #{logo_data[:filename]}"
      else
        puts "❌ Failed to attach logo for #{team.name}"
      end
    else
      puts "⚠️  Logo file not found: #{logo_path}"
      puts "   Expected: #{logo_data[:filename]} for #{team.name}"
    end
  else
    puts "❌ Team not found: #{logo_data[:team_name]}"
  end
end

puts "\n📊 Logo Attachment Summary:"
teams_with_logos = organization.teams.joins(:logo_attachment).count
total_teams = organization.teams.count
puts "Teams with logos: #{teams_with_logos}/#{total_teams}"

puts "\n💡 To download logos:"
puts "1. Visit the URLs provided in the logo_finder.rb output"
puts "2. Save images as PNG files in app/assets/images/team_logos/"
puts "3. Use the exact filenames shown above"
puts "4. Run this script again: bundle exec rails runner db/seeds/attach_logos.rb"
