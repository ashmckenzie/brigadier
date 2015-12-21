require 'brigadier'

# You can run like so:
#
# ruby intermediate.rb
# ruby intermediate.rb --help
# ruby intermediate.rb guest
# ruby intermediate.rb guest --help
# ruby intermediate.rb guest --debug 'John Smith'

module Commands
  class Intermediate
    extend Brigadier

    toggle 'debug', 'Debugging toggle'
    toggle 'verbose', 'Verbose mode', default: true

    sub_command 'guest', 'Guest sub command' do
      argument 'name', 'Name of guest', required: true

      execute do
        puts "Inside guest sub command's \#execute: name: #{name}, debug?: #{debug?}, verbose?: #{verbose?}"
      end
    end
  end
end

Brigadier::Runner.new(ARGV).run(Commands::Intermediate)
