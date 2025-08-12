# Pry Debugging Setup - Complete! ✅

## What's Been Installed

### Gems Added
- **pry** - Main REPL/debugger
- **pry-rails** - Rails integration (better console, model inspection)
- **pry-byebug** - Step debugging (next, step, continue)
- **launchy** - For `save_and_open_page` browser opening

### Files Created
1. `spec/support/pry.rb` - Pry configuration
2. `spec/features/admin/organizations_debug_example_spec.rb` - Example debugging test
3. `bin/debug_test` - Convenient test runner script
4. `DEBUG_GUIDE.md` - Comprehensive debugging guide

## Quick Start

### 1. Add a breakpoint to any test:
```ruby
scenario "some test" do
  visit some_path
  binding.pry  # Execution will pause here
  expect(page).to have_content("something")
end
```

### 2. Run with debugging:
```bash
# Option 1: Use debug script
./bin/debug_test spec/features/admin/organizations_debug_example_spec.rb

# Option 2: Set environment variable
DEBUG=1 bundle exec rspec spec/features/admin/organizations_debug_example_spec.rb

# Option 3: Just run normally (will break on binding.pry)
bundle exec rspec spec/features/admin/organizations_spec.rb
```

## Most Useful Commands in Pry During Feature Tests

### Page Investigation
```ruby
page.body                    # See full HTML
page.text                    # See just text content
save_and_open_page          # Open current page in browser
current_path                # Current URL path
```

### Navigation
```ruby
c          # Continue execution
n          # Next line
s          # Step into
whereami   # Show current location
exit       # Exit pry session
```

### Database Checking
```ruby
User.count
Organization.last
Organization.where(name: "Test")
```

## Ready to Use Examples

### In your existing tests, add debugging like this:

```ruby
scenario "creating an organization" do
  visit admin_organizations_path
  
  # Debug the initial page
  debug_page("Before clicking New Organization") if ENV['DEBUG']
  
  click_link "New Organization"
  
  # Debug the form
  debug_page("On the form page") if ENV['DEBUG']
  
  fill_in "Name", with: "Test District"
  select "Active", from: "Status"
  click_button "Create Organization"
  
  # Debug the result
  debug_page("After form submission") if ENV['DEBUG']
  
  expect(page).to have_content("Test District")
end
```

### Or use the simple approach:

```ruby
scenario "debugging something specific" do
  visit admin_organizations_path
  
  binding.pry  # Always break here
  
  # Continue with test...
end
```

## Test It Out

Run the example debug test to make sure everything works:

```bash
./bin/debug_test spec/features/admin/organizations_debug_example_spec.rb
```

This will show you the debugging interface and let you practice using Pry commands.

## What You Can Debug

✅ **Page content** - See what HTML is rendered  
✅ **Form values** - Check what data was entered  
✅ **Database state** - Verify records are created/updated  
✅ **Current location** - Know which page you're on  
✅ **Element attributes** - Inspect CSS classes, IDs, etc.  
✅ **User authentication** - Check who's logged in  
✅ **Session data** - Examine session contents  

## Quick Reference

- 📚 Full guide: `DEBUG_GUIDE.md`
- 🧪 Example test: `spec/features/admin/organizations_debug_example_spec.rb`
- 🛠️ Debug script: `./bin/debug_test <test_file>`
- ⚙️ Configuration: `spec/support/pry.rb`

Your Pry debugging environment is now fully set up and ready to use! 🎉
