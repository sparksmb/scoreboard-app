# Logo Finder Helper Script
# This script provides URLs and search suggestions for Texas High School logos

puts "🏈 Texas High School Football Team Logo Resources"
puts "=" * 50

logo_resources = [
  {
    name: "Forney Jackrabbits",
    suggested_urls: [
      "https://www.forneyisd.net/schools/forney-high-school",
      "https://www.maxpreps.com/high-schools/forney-jackrabbits-(forney,tx)/football/home.htm"
    ],
    notes: "Primary team - Navy blue and gold colors, jackrabbit mascot"
  },
  {
    name: "Rowlett Eagles", 
    suggested_urls: [
      "https://www.risd.org/rowletths",
      "https://www.maxpreps.com/high-schools/rowlett-eagles-(rowlett,tx)/football/home.htm"
    ],
    notes: "Red and white colors, eagle mascot"
  },
  {
    name: "Lake Highlands Wildcats",
    suggested_urls: [
      "https://www.risd.org/lakehighlandshs",
      "https://www.maxpreps.com/high-schools/lake-highlands-wildcats-(dallas,tx)/football/home.htm"
    ],
    notes: "Part of Richardson ISD, navy and gold colors"
  },
  {
    name: "A&M Consolidated Tigers",
    suggested_urls: [
      "https://www.csisd.org/amchs",
      "https://www.maxpreps.com/high-schools/a-and-m-consolidated-tigers-(college-station,tx)/football/home.htm"
    ],
    notes: "College Station ISD, maroon and white (A&M colors)"
  },
  {
    name: "Waxahachie Indians",
    suggested_urls: [
      "https://www.wisd.org/whs",
      "https://www.maxpreps.com/high-schools/waxahachie-indians-(waxahachie,tx)/football/home.htm"
    ],
    notes: "Red and black colors, traditional program"
  },
  {
    name: "Boswell Pioneers",
    suggested_urls: [
      "https://www.eanesisd.net/boswell", # Note: There may be multiple Boswell schools
      "https://www.maxpreps.com/high-schools/boswell-pioneers-(fort-worth,tx)/football/home.htm"
    ],
    notes: "Fort Worth area, navy and silver colors"
  },
  {
    name: "North Forney Falcons",
    suggested_urls: [
      "https://www.forneyisd.net/schools/north-forney-high-school",
      "https://www.maxpreps.com/high-schools/north-forney-falcons-(forney,tx)/football/home.htm"
    ],
    notes: "Sister school to Forney, red and black colors"
  },
  {
    name: "Royse City Bulldogs",
    suggested_urls: [
      "https://www.rcisd.org/rcisd/high-school",
      "https://www.maxpreps.com/high-schools/royse-city-bulldogs-(royse-city,tx)/football/home.htm"
    ],
    notes: "Navy and gold colors, bulldog mascot"
  },
  {
    name: "Longview Lobos",
    suggested_urls: [
      "https://www.longviewisd.org/lhs",
      "https://www.maxpreps.com/high-schools/longview-lobos-(longview,tx)/football/home.htm"
    ],
    notes: "Historic program, white and navy colors"
  },
  {
    name: "Rockwall Yellowjackets",
    suggested_urls: [
      "https://www.rockwallisd.com/rhs",
      "https://www.maxpreps.com/high-schools/rockwall-yellowjackets-(rockwall,tx)/football/home.htm"
    ],
    notes: "Gold and black colors, yellowjacket mascot"
  },
  {
    name: "Tyler Legacy Red Raiders", 
    suggested_urls: [
      "https://www.tylerisd.org/tylerlegacy",
      "https://www.maxpreps.com/high-schools/tyler-legacy-red-raiders-(tyler,tx)/football/home.htm"
    ],
    notes: "Newer school, red and black colors"
  },
  {
    name: "Rockwall Heath Hawks",
    suggested_urls: [
      "https://www.rockwallisd.com/rhhs", 
      "https://www.maxpreps.com/high-schools/rockwall-heath-hawks-(rockwall,tx)/football/home.htm"
    ],
    notes: "Navy and silver colors, hawk mascot"
  }
]

logo_resources.each_with_index do |team, index|
  puts "\n#{index + 1}. #{team[:name]}"
  puts "   Notes: #{team[:notes]}"
  puts "   Suggested URLs to check:"
  team[:suggested_urls].each do |url|
    puts "   • #{url}"
  end
end

puts "\n" + "=" * 50
puts "📋 LOGO SEARCH INSTRUCTIONS:"
puts "1. Visit each school's official website first"
puts "2. Check MaxPreps for team logos and colors"
puts "3. Search '[School Name] logo PNG' on Google Images"
puts "4. Look for official athletic department websites"
puts "5. Check Texas UIL (University Interscholastic League) resources"
puts "6. Social media accounts often have high-quality logos"

puts "\n🔍 Additional Resources:"
puts "• Texas UIL: https://www.uiltexas.org/"
puts "• MaxPreps: https://www.maxpreps.com/"
puts "• Individual school district websites"
puts "• Athletic Booster Club websites"
puts "• Local newspaper sports sections"

puts "\n💾 Once you find logos:"
puts "1. Download as high-resolution PNG files"
puts "2. Name files like: 'forney_jackrabbits_logo.png'"
puts "3. Place in app/assets/images/team_logos/"
puts "4. Update seed file to attach logos to teams"

# Create directory for team logos if it doesn't exist
logo_dir = Rails.root.join('app', 'assets', 'images', 'team_logos')
FileUtils.mkdir_p(logo_dir) unless Dir.exist?(logo_dir)
puts "\n📁 Created directory: #{logo_dir}"
