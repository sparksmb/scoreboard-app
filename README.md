# Scoreboard App

A Ruby on Rails application for high school sports broadcasting, providing real-time scoreboard management for Football, Basketball, and Baseball games.

## Features

- **Multi-Sport Support**: Football, Basketball, and Baseball scoreboards
- **Organization Management**: Multi-school district support with admin controls
- **Real-time Updates**: ActionCable integration for live scoreboard updates
- **OBS Integration**: Web-based scoreboard for broadcast streaming
- **Admin Interface**: Full CRUD operations for organizations and games
- **User Authentication**: Role-based access with admin and regular users

## Tech Stack

- **Framework**: Ruby on Rails 7.2
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Real-time**: ActionCable
- **Testing**: RSpec with Capybara
- **Deployment**: Docker + Heroku ready
- **Debugging**: Pry with enhanced screenshot capabilities

## Current Status

✅ **Phase 1 Complete**: Admin Organization Management
- User authentication and authorization
- Organization CRUD operations
- Comprehensive test coverage
- Admin web interface

🚧 **Phase 2 In Progress**: Football Scoreboard Implementation
- Season and Game management
- Football-specific scoreboard features
- Live scoreboard display

## Quick Start

### Prerequisites
- Ruby 3.2+
- PostgreSQL
- Node.js (for ActionCable)

### Setup

```bash
# Clone the repository
git clone https://github.com/sparksmb/scoreboard-app.git
cd scoreboard-app

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate

# Create admin user
rails runner "User.create!(email: 'admin@example.com', password: 'password123', password_confirmation: 'password123', first_name: 'Admin', last_name: 'User', admin: true)"

# Start the server
rails server
```

Visit http://localhost:3000 and sign in with `admin@example.com` / `password123`

## Testing

```bash
# Run all tests
bundle exec rspec

# Run with debugging
DEBUG=1 bundle exec rspec spec/features/

# Enhanced screenshot debugging
./bin/debug_test spec/features/admin/organizations_spec.rb
```

## Documentation

- 📋 [Requirements & Design](doc/BACKGROUND_REQUIREMENTS_DESIGN.md)
- 🐛 [Pry Debugging Guide](doc/DEBUG_GUIDE.md)
- 📸 [Screenshot Guide](doc/SCREENSHOT_GUIDE.md)
- 🔧 [Setup Summaries](doc/)

## Project Structure

```
app/
├── controllers/
│   ├── admin/              # Admin interface controllers
│   ├── api/v1/            # API endpoints
│   └── web_application_controller.rb
├── models/
│   ├── organization.rb    # School districts
│   ├── user.rb           # Admin and regular users
│   └── ...               # Game, Team, Scoreboard models
└── views/
    └── admin/            # Admin web interface

spec/
├── features/             # Capybara browser tests
├── models/              # Model unit tests
└── support/             # Test helpers and configuration
```

## Contributing

This is a project for Forney ISD high school sports broadcasting. Current development focus:

1. **Football Scoreboard Features** - Complete game management and live scoring
2. **Real-time Broadcasting** - ActionCable integration with OBS
3. **Mobile Interface** - Responsive design for mobile scorekeeping
4. **Additional Sports** - Basketball and Baseball scoreboard implementations

## License

Private project for Forney ISD.

---

**Built with ❤️ for high school sports broadcasting**
