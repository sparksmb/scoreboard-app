#!/usr/bin/env ruby

puts "=== Scoreboard App - Admin Organization Management Demo ==="
puts

# Start the Rails server in background
puts "1. Starting Rails server..."
system("rails server --daemon --pid=tmp/pids/demo_server.pid")
sleep 3

puts "2. Server running on http://localhost:3000"
puts

puts "3. Created data:"
puts "   - Admin user: admin@example.com / password123"
puts "   - Regular org: Test School District"
puts

puts "4. You can now:"
puts "   - Visit http://localhost:3000 (should redirect to sign in)"
puts "   - Sign in as admin@example.com / password123"
puts "   - View the organizations list"
puts "   - Create, edit, and delete organizations"
puts

puts "5. Press Enter to stop the server when done testing..."
STDIN.gets

# Stop the server
if File.exist?("tmp/pids/demo_server.pid")
  pid = File.read("tmp/pids/demo_server.pid").strip
  system("kill #{pid}")
  puts "Server stopped."
else
  puts "Server PID file not found."
end
