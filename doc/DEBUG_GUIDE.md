# Debugging Guide for Feature Tests with Pry

This guide shows you how to debug your Capybara feature tests using Pry.

## Getting Started

### 1. Adding a Breakpoint

Add `binding.pry` anywhere in your test where you want to pause execution:

```ruby
scenario "debugging a test" do
  login_as(admin_user, scope: :user)
  visit admin_organizations_path
  
  # Pause here to inspect the page
  binding.pry
  
  expect(page).to have_content("Organizations")
end
```

### 2. Running Tests with Debugging

#### Option 1: Use the debug script
```bash
./bin/debug_test spec/features/admin/organizations_debug_example_spec.rb
```

#### Option 2: Set DEBUG environment variable
```bash
DEBUG=1 bundle exec rspec spec/features/admin/organizations_debug_example_spec.rb
```

#### Option 3: Always break (remove the ENV['DEBUG'] condition)
```ruby
# This will always break, regardless of environment
binding.pry
```

## Useful Pry Commands for Feature Tests

### Page Inspection
```ruby
# View the current page HTML
page.body

# View just the text content
page.text

# Get current URL
current_path

# Check if text exists on page
page.has_content?("Some text")

# Find elements
page.find("h1")
page.find("#some-id")
page.all("tr")
```

### Opening Pages in Browser
```ruby
# Save current page and open in browser
save_and_open_page

# Save to a specific file
save_page("debug.html")
```

### Form Debugging
```ruby
# Find form fields
page.find_field("Name")
page.find_field("Status")

# Check form values
page.find_field("Name").value
```

### Navigation and State
```ruby
# Current user (if using Warden helpers)
current_user if defined?(current_user)

# Check session data
page.driver.request.session if page.driver.respond_to?(:request)
```

### Database Inspection
```ruby
# Check database state
User.count
Organization.count
Organization.last
```

### Basic Pry Navigation
- `c` or `continue` - Continue execution
- `n` or `next` - Next line
- `s` or `step` - Step into method
- `l` or `list` - Show current code
- `whereami` - Show current location in code
- `exit` - Exit pry session
- `!!!` - Exit immediately

### Advanced Debugging
```ruby
# Inspect element attributes
element = page.find("h1")
element.text
element[:class]
element[:id]

# Check CSS selectors
page.has_css?("h1")
page.has_css?(".btn")
page.has_css?("#user-menu")

# Inspect page structure
puts page.body # Raw HTML
puts page.text # Just text content
```

## Example Debugging Session

Here's what a typical debugging session looks like:

```ruby
scenario "creating an organization with debugging" do
  login_as(admin_user, scope: :user)
  visit admin_organizations_path
  
  # Break here to inspect initial page
  binding.pry
  # In pry console:
  # > page.has_content?("Organizations")  # => true
  # > page.find("h2").text               # => "Organizations"
  # > current_path                       # => "/admin/organizations"
  
  click_link "New Organization"
  
  # Break to inspect form page
  binding.pry
  # In pry console:
  # > page.has_content?("New Organization")  # => true
  # > page.find_field("Name")                # => <input...>
  # > save_and_open_page                     # Opens browser
  
  fill_in "Name", with: "Test District"
  select "Active", from: "Status"
  
  # Break before submission
  binding.pry
  # In pry console:
  # > page.find_field("Name").value      # => "Test District"
  # > Organization.count                 # => 1 (before creation)
  
  click_button "Create Organization"
  
  # Break after submission to check result
  binding.pry
  # In pry console:
  # > Organization.count                 # => 2 (after creation)
  # > Organization.last.name             # => "Test District"
  # > current_path                       # => "/admin/organizations/2"
end
```

## Troubleshooting Common Issues

### Page Not Loading
```ruby
# Check if page loaded
page.status_code  # Should be 200

# Check for errors
page.body.include?("error")
```

### Element Not Found
```ruby
# List all links
page.all("a").each { |link| puts link.text }

# List all buttons  
page.all("button, input[type=submit]").each { |btn| puts btn.value || btn.text }

# Check exact text matching
page.has_content?("Exact Text", exact: true)
```

### Form Issues
```ruby
# Check if field exists
page.has_field?("Name")

# Check field type
field = page.find_field("Status")
field.tag_name    # => "select"
field[:type]      # => nil for select

# List all options in select
page.find("select[name='organization[active]'] option").each { |opt| puts opt.text }
```

## Tips for Effective Debugging

1. **Use conditional breakpoints** - Only break when needed with `binding.pry if condition`
2. **Save pages frequently** - Use `save_and_open_page` to see exactly what the test sees
3. **Check the database** - Verify data state with direct ActiveRecord queries
4. **Inspect elements** - Use `page.find()` to get element details
5. **Test selectors** - Verify your CSS selectors work with `page.has_css?()`

## Integration with Your Tests

You can add debugging to any existing test by simply adding `binding.pry` at the point where you want to inspect the state:

```ruby
# In your existing tests
scenario "editing an organization" do
  # ... setup code ...
  
  visit admin_organization_path(org)
  binding.pry if ENV['DEBUG']  # Only break if DEBUG is set
  
  # ... rest of test ...
end
```

This way you can run tests normally, but enable debugging when needed by setting the DEBUG environment variable.
