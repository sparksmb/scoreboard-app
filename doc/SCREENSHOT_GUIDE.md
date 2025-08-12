# Screenshot Guide for Feature Tests

Your enhanced screenshot system provides multiple ways to capture and view page states during testing.

## Available Screenshot Methods

### 1. `ss` - Enhanced Screenshot Method

The main screenshot method with flexible options:

```ruby
# Basic screenshot - saves with timestamp and opens automatically
ss

# Named screenshot - custom name for easy identification  
ss(name: "login_form")

# Full page screenshot - captures entire scrollable page
ss(full_page: true)

# Named full page screenshot
ss(name: "full_dashboard", full_page: true)

# Screenshot without auto-opening
ss(name: "debug_state", open: false)
```

**Options:**
- `name:` - Custom name for the screenshot file
- `full_page:` - Capture entire scrollable page (default: false)
- `open:` - Automatically open the screenshot (default: true)

### 2. `ss_full` - Full Page Screenshots

Convenience method for full page captures:

```ruby
# Full page screenshot with auto-open
ss_full

# Named full page screenshot
ss_full(name: "complete_page")

# Full page without auto-opening
ss_full(name: "full_debug", open: false)
```

### 3. `ss_quiet` - Silent Screenshots

Take screenshots without automatically opening them:

```ruby
# Quiet screenshot - saves but doesn't open
ss_quiet

# Named quiet screenshot
ss_quiet(name: "background_capture")

# Quiet full page screenshot
ss_quiet(name: "full_silent", full_page: true)
```

### 4. `debug_screenshot` - Debug Helper

Part of the debug helpers, integrates with other debugging tools:

```ruby
# Quick debug screenshot
debug_screenshot("form_state")

# Use with other debug helpers
debug_page_info
debug_screenshot("after_debug_info")
```

## Integration with Launchy

The enhanced `ss` method tries to use `launchy` first, then falls back to system commands:

1. **Launchy** (if available) - Cross-platform file opening
2. **macOS** - Uses `open` command
3. **Linux** - Uses `xdg-open` command
4. **Other platforms** - Shows path but can't auto-open

## Practical Usage Examples

### Basic Debugging Workflow

```ruby
scenario "debugging form submission" do
  login_as(user, scope: :user)
  visit new_organization_path
  
  # Take screenshot of initial form
  ss(name: "empty_form")
  
  fill_in "Name", with: "Test Org"
  select "Active", from: "Status"
  
  # Screenshot filled form before submission
  ss(name: "filled_form") 
  
  click_button "Create Organization"
  
  # Screenshot result page
  ss(name: "after_submission")
  
  expect(page).to have_content("Test Org")
end
```

### Screenshot on Test Failure

```ruby
scenario "with failure screenshot" do
  login_as(user, scope: :user)
  visit organizations_path
  
  begin
    expect(page).to have_content("Expected content")
  rescue RSpec::Expectations::ExpectationNotMetError => e
    # Take screenshot on failure for debugging
    ss(name: "test_failure_#{Time.now.to_i}")
    raise e  # Re-raise the original error
  end
end
```

### Combined with Pry Debugging

```ruby
scenario "comprehensive debugging" do
  login_as(user, scope: :user)
  visit organizations_path
  
  # Take screenshot and break for inspection
  ss(name: "before_debug", open: false)
  binding.pry
  
  # In pry console, you can:
  # > ss(name: "pry_screenshot")
  # > debug_everything("detailed_inspection")
  
  click_link "New Organization"
  # ... continue test
end
```

### Environment-Controlled Screenshots

```ruby
scenario "conditional screenshots" do
  visit organizations_path
  
  # Only take screenshots when debugging
  ss(name: "initial_state") if ENV['DEBUG']
  
  click_link "New Organization"
  
  # Take screenshot and break only in debug mode
  if ENV['DEBUG']
    ss(name: "form_page", open: true)
    binding.pry
  end
  
  # Continue with test...
end
```

## Screenshot File Organization

Screenshots are saved with descriptive names and timestamps:

```
tmp/capybara/
├── screenshot-20250112-143052.png          # Basic ss()
├── login_form-20250112-143053.png          # ss(name: "login_form") 
├── full_dashboard-20250112-143054.png      # ss_full(name: "full_dashboard")
└── debug_organizations-20250112-143055.png # debug_screenshot("debug_organizations")
```

## Best Practices

### 1. Use Descriptive Names

```ruby
# Good - tells you what you're looking at
ss(name: "login_form_validation_errors")
ss(name: "dashboard_after_org_creation")

# Less helpful
ss(name: "test1")
ss(name: "debug")
```

### 2. Screenshot Before and After Actions

```ruby
# Before important actions
ss(name: "before_form_submission")
click_button "Submit"
ss(name: "after_form_submission")
```

### 3. Use Quiet Mode for Automated Screenshots

```ruby
# When taking many screenshots, use quiet mode
ss_quiet(name: "step_#{step_number}")
```

### 4. Full Page for Complex Layouts

```ruby
# For dashboards or long forms
ss_full(name: "complete_dashboard_view")
```

### 5. Combine with Debug Information

```ruby
if ENV['DEBUG']
  debug_page_info
  debug_database_state  
  ss(name: "debug_with_context", open: true)
  binding.pry
end
```

## Troubleshooting

### Screenshots Not Opening Automatically

1. **Check launchy installation**: `gem list launchy`
2. **Check system commands**: `which open` (macOS) or `which xdg-open` (Linux)
3. **Use manual opening**: `ss(name: "test", open: false)` then open the file manually

### Screenshot Path Issues

```ruby
# Check where screenshots are being saved
puts Capybara.save_path || 'tmp/capybara'

# Check if file was actually created
path = ss(name: "test", open: false)
puts "Screenshot exists: #{File.exist?(path)}" if path
```

### Empty or Black Screenshots

- This usually happens with headless browsers
- Try taking full page screenshots: `ss_full()`
- Ensure page is fully loaded before screenshot
- Add a small delay: `sleep 1; ss(name: "after_delay")`

## Quick Reference

| Method | Purpose | Auto-opens | Example |
|--------|---------|------------|---------|
| `ss` | Basic screenshot | Yes | `ss(name: "form")` |
| `ss_full` | Full page capture | Yes | `ss_full(name: "dashboard")` |
| `ss_quiet` | Silent capture | No | `ss_quiet(name: "background")` |
| `debug_screenshot` | Debug helper | No | `debug_screenshot("state")` |

## Integration with Your Workflow

Add screenshots to your existing debugging workflow:

```ruby
# In any test where you use binding.pry:
binding.pry

# In the pry console, you can now use:
> ss(name: "pry_debug")           # Take and open screenshot
> ss_quiet(name: "silent")        # Take without opening  
> debug_everything("full_debug")  # Complete debug + screenshot
```

Your enhanced screenshot system provides powerful visual debugging capabilities that integrate seamlessly with Pry and your existing test workflow!
