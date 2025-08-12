# Debug helpers for feature tests
module DebugHelpers
  # Quick page inspection
  def debug_page_info
    puts "\n" + "="*50
    puts "🐛 DEBUG INFO"
    puts "="*50
    puts "📍 Current path: #{current_path}"
    puts "📊 Status code: #{page.status_code}"
    puts "📝 Page title: #{page.find('title', visible: false).text rescue 'No title'}"
    puts "🔍 Page has content: #{page.has_content?('Organizations') ? '✅' : '❌'}"
    puts "="*50
  end
  
  # Quick form debugging
  def debug_form_state
    puts "\n" + "="*50
    puts "📝 FORM DEBUG"
    puts "="*50
    
    # Find all form fields
    fields = page.all('input, select, textarea')
    fields.each do |field|
      name = field[:name] || field[:id] || 'unnamed'
      value = field.value || field.text
      type = field[:type] || field.tag_name
      puts "  #{type.upcase}: #{name} = '#{value}'"
    end
    puts "="*50
  end
  
  # Quick database state check
  def debug_database_state
    puts "\n" + "="*50
    puts "🗄️ DATABASE STATE"
    puts "="*50
    puts "👥 Users: #{User.count}"
    puts "🏢 Organizations: #{Organization.count}"
    if Organization.any?
      puts "   Last org: #{Organization.last.name} (#{Organization.last.active? ? 'active' : 'inactive'})"
    end
    puts "="*50
  end
  
  # Comprehensive debug - shows everything
  def debug_everything(message = "Debug checkpoint")
    puts "\n" + "🐛 #{message} ".ljust(50, "=")
    debug_page_info
    debug_form_state if page.has_css?('form')
    debug_database_state
    binding.pry
  end
  
  # Quick screenshot for headless debugging (uses the enhanced ss method)
  def debug_screenshot(name = "debug_screenshot")
    ss(name: name, open: false)  # Use the enhanced ss method without auto-opening
  end
end

# Include in all feature tests
RSpec.configure do |config|
  config.include DebugHelpers, type: :feature
end
