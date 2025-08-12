# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'shoulda-matchers'
require 'database_cleaner/active_record'
require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# Ensures that the test database schema matches the current schema file.
# If there are pending migrations it will invoke `db:test:prepare` to
# recreate the test database by loading the schema.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails uses metadata to mix in different behaviours to your tests,
  # for example enabling you to call `get` and `post` in request specs. e.g.:
  #
  #     RSpec.describe UsersController, type: :request do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/8-0/rspec-rails
  #
  # You can also this infer these behaviours automatically by location, e.g.
  # /spec/models would pull in the same behaviour as `type: :model` but this
  # behaviour is considered legacy and will be removed in a future version.
  #
  # To enable this behaviour uncomment the line below.
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  
  # FactoryBot configuration
  config.include FactoryBot::Syntax::Methods
  
  # Database Cleaner configuration
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  
  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end
  
  config.before(:each) do
    DatabaseCleaner.start
  end
  
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Shoulda Matchers configuration
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Capybara configuration
Capybara.register_driver :chrome_headless do |app|
  capabilities = Selenium::WebDriver::Chrome::Options.new
  capabilities.add_argument '--headless'
  capabilities.add_argument '--no-sandbox'
  capabilities.add_argument '--disable-dev-shm-usage'
  capabilities.add_argument '--disable-gpu'
  capabilities.add_argument '--window-size=1400,1400'
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: capabilities)
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :chrome_headless


# Enhanced screenshot method with launchy integration
def ss(name: nil, full_page: false, open: true)
  timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
  base_name = name ? "#{name}-#{timestamp}" : "screenshot-#{timestamp}"
  filename = "#{base_name}.png"
  
  begin
    if full_page
      # Capture full page by scrolling and taking multiple screenshots
      page.save_screenshot(filename, full: true)
    else
      page.save_screenshot(filename)
    end
    
    # Get the full path to the screenshot
    full_path = File.join(Capybara.save_path || 'tmp/capybara', filename)
    
    puts "\n📸 Screenshot saved: #{full_path}"
    
    if open
      # Try launchy first, fall back to system open
      if defined?(Launchy)
        begin
          Launchy.open(full_path)
          puts "🔍 Opening with Launchy..."
        rescue => e
          puts "⚠️  Launchy failed (#{e.message}), trying system open..."
          system("open '#{full_path}'") if RUBY_PLATFORM.include?('darwin') # macOS
          system("xdg-open '#{full_path}'") if RUBY_PLATFORM.include?('linux') # Linux
        end
      else
        # Fall back to system commands
        if RUBY_PLATFORM.include?('darwin') # macOS
          system("open '#{full_path}'")
        elsif RUBY_PLATFORM.include?('linux') # Linux  
          system("xdg-open '#{full_path}'")
        else
          puts "🤷 Don't know how to open images on #{RUBY_PLATFORM}"
        end
      end
    end
    
    full_path
  rescue => e
    puts "❌ Screenshot failed: #{e.message}"
    nil
  end
end

# Convenience methods
def ss_full(name: nil, open: true)
  ss(name: name, full_page: true, open: open)
end

def ss_quiet(name: nil, full_page: false)
  ss(name: name, full_page: full_page, open: false)
end

