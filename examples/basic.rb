require 'brigadier'

# You can run like so:
#
# ruby basic.rb --help
# ruby basic.rb

class BasicCommand
  extend Brigadier

  toggle 'debug', 'Debugging toggle'
  toggle 'verbose', 'Verbose mode', default: true

  execute do
    puts "Inside \#execute - debug?: #{debug?}, verbose?: #{verbose?}"
  end
end

Brigadier::Runner.new(ARGV).run(BasicCommand)
