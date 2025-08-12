source "https://rubygems.org"

gem "awesome_print"
gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# gem "jbuilder"
# gem "redis", ">= 4.0.1"
# gem "kredis"
# gem "bcrypt", "~> 3.1.7"

gem "devise"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
# gem "image_processing", "~> 1.2"
# gem "rack-cors"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry"
  gem "pry-rails"
  gem "pry-byebug"
end

group :test do
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "launchy"  # For save_and_open_page in tests
end

