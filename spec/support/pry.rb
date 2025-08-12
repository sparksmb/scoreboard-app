require 'pry'

# Configure Pry for better debugging experience
Pry.config.editor = 'code --wait' if system('which code > /dev/null 2>&1')

# Add helpful commands for debugging
Pry::Commands.create_command "sql" do
  description "Show the last SQL queries"
  
  def process
    if defined?(ActiveRecord)
      puts ActiveRecord::Base.connection.instance_variable_get(:@query_cache)&.keys&.last(5) || "No recent queries"
    else
      puts "ActiveRecord not available"
    end
  end
end

# Color coding for better visibility
Pry.config.color = true
Pry.config.prompt = Pry::Prompt.new(
  "custom",
  "Custom Pry Prompt",
  [
    proc { |target_self, nest_level, pry| 
      "[#{pry.input_ring.size}] pry(#{Pry.view_clip(target_self)})#{":#{nest_level}" unless nest_level.zero?}> "
    },
    proc { |target_self, nest_level, pry|
      "[#{pry.input_ring.size}] pry(#{Pry.view_clip(target_self)})#{":#{nest_level}" unless nest_level.zero?}* "
    }
  ]
)
