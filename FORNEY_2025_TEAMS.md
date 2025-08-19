# Forney 2025 Texas High School Football Teams

## Overview
This document summarizes the Texas high school football teams created from the Forney Jackrabbits 2025 schedule poster.

## Teams Created (12 total)

| Team | Mascot | Location | Colors | Logo Search Terms |
|------|--------|----------|--------|-------------------|
| Forney Jackrabbits | Jackrabbits | Forney, TX | Navy Blue (#000080) / Gold (#FFD700) | Forney High School Jackrabbits logo |
| Rowlett Eagles | Eagles | Rowlett, TX | Dark Red (#8B0000) / White (#FFFFFF) | Rowlett High School Eagles logo |
| Lake Highlands Wildcats | Wildcats | Dallas, TX | Navy Blue (#000080) / Gold (#FFD700) | Lake Highlands High School Wildcats logo Dallas |
| A&M Consolidated Tigers | Tigers | College Station, TX | Maroon (#500000) / White (#FFFFFF) | A&M Consolidated High School Tigers logo College Station |
| Waxahachie Indians | Indians | Waxahachie, TX | Dark Red (#8B0000) / Black (#000000) | Waxahachie High School Indians logo |
| Boswell Pioneers | Pioneers | Fort Worth, TX | Navy Blue (#000080) / Silver (#C0C0C0) | Boswell High School Pioneers logo Fort Worth |
| North Forney Falcons | Falcons | Forney, TX | Dark Red (#8B0000) / Black (#000000) | North Forney High School Falcons logo |
| Royse City Bulldogs | Bulldogs | Royse City, TX | Navy Blue (#000080) / Gold (#FFD700) | Royse City High School Bulldogs logo |
| Longview Lobos | Lobos | Longview, TX | White (#FFFFFF) / Navy Blue (#000080) | Longview High School Lobos logo |
| Rockwall Yellowjackets | Yellowjackets | Rockwall, TX | Gold (#FFD700) / Black (#000000) | Rockwall High School Yellowjackets logo |
| Tyler Legacy Red Raiders | Red Raiders | Tyler, TX | Dark Red (#8B0000) / Black (#000000) | Tyler Legacy High School Red Raiders logo |
| Rockwall Heath Hawks | Hawks | Rockwall, TX | Navy Blue (#000080) / Silver (#C0C0C0) | Rockwall Heath High School Hawks logo |

## 2025 Schedule (11 games)

| Date | Home Team | Visitor Team | Location |
|------|-----------|--------------|----------|
| Aug 28, 2025 | Lake Highlands Wildcats | Forney Jackrabbits | Lake Highlands High School |
| Aug 29, 2025 | Forney Jackrabbits | Rowlett Eagles | Forney High School |
| Sep 05, 2025 | A&M Consolidated Tigers | Forney Jackrabbits | A&M Consolidated High School |
| Sep 12, 2025 | Forney Jackrabbits | Waxahachie Indians | Forney High School |
| Sep 19, 2025 | Boswell Pioneers | Forney Jackrabbits | Boswell High School |
| Sep 26, 2025 | Forney Jackrabbits | North Forney Falcons | Forney High School |
| Oct 03, 2025 | Royse City Bulldogs | Forney Jackrabbits | Royse City High School |
| Oct 10, 2025 | Forney Jackrabbits | Longview Lobos | Forney High School |
| Oct 17, 2025 | Rockwall Yellowjackets | Forney Jackrabbits | Rockwall High School |
| Oct 31, 2025 | Forney Jackrabbits | Tyler Legacy Red Raiders | Forney High School |
| Nov 06, 2025 | Rockwall Heath Hawks | Forney Jackrabbits | Rockwall Heath High School |

*Note: Open Week on Oct 24 was skipped as it's not a game.*

## Files Created

### Seed Files
- `db/seeds/forney_2025_teams.rb` - Main seed file that creates all teams and games
- `db/seeds/logo_finder.rb` - Helper script with logo search resources  
- `db/seeds/attach_logos.rb` - Script to attach logo files after download

### Directory
- `app/assets/images/team_logos/` - Directory for team logo files

## Usage

### 1. Run the seed file
```bash
bundle exec rails runner db/seeds/forney_2025_teams.rb
```

### 2. Find and download logos
```bash
bundle exec rails runner db/seeds/logo_finder.rb
```

### 3. Attach logos (after downloading)
```bash
bundle exec rails runner db/seeds/attach_logos.rb
```

## Logo Resources

### Primary Resources
- Official school district websites
- MaxPreps team pages
- Texas UIL (https://www.uiltexas.org/)
- Google Images search: "[School Name] logo PNG"

### Expected Logo Filenames
- `forney_jackrabbits_logo.png`
- `rowlett_eagles_logo.png`
- `lake_highlands_wildcats_logo.png`
- `am_consolidated_tigers_logo.png`
- `waxahachie_indians_logo.png`
- `boswell_pioneers_logo.png`
- `north_forney_falcons_logo.png`
- `royse_city_bulldogs_logo.png`
- `longview_lobos_logo.png`
- `rockwall_yellowjackets_logo.png`
- `tyler_legacy_red_raiders_logo.png`
- `rockwall_heath_hawks_logo.png`

## Organization
All teams and games are associated with the "Texas High School Football" organization in the database.

## Notes
- Team colors were estimated based on common school colors and mascots
- Some school locations were generalized (e.g., Lake Highlands as Dallas)
- Logo search terms include variations to help with finding official logos
- All teams and games can be re-run safely (find_or_create_by prevents duplicates)
