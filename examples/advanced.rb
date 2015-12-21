require 'brigadier'

# You can run like so:
#
# ruby advanced.rb --help
# ruby advanced.rb
# ruby advanced.rb --debug
# ruby advanced.rb admin --help
# ruby advanced.rb admin
# ruby advanced.rb admin 'Poopy McPoopy'
# ruby advanced.rb admin 'John Smith'
# ruby advanced.rb admin --age 27 'John Smith'
# ruby advanced.rb admin --age 200 'John Smith' 'john@smith.com'
# ruby advanced.rb admin --important 'John Smith' 'john@smith.com'
# ruby advanced.rb admin --not-sensitive 'John Smith' 'john@smith.com'

module CustomValidations
  class AntiPooper
    include Brigadier::Validators::Base

    def failure_message
      "Please don't mention poop."
    end

    def valid?
      !value.match(/poop/i)
    end
  end

  class SensibleAge
    include Brigadier::Validators::Base

    VALID_AGE_START = 20
    VALID_AGE_END = 100

    def failure_message
      '%s is not a sensible age (needs to be between %s and %s)' % [ value, VALID_AGE_START, VALID_AGE_END ]
    end

    def value
      obj.value.to_i
    end

    def valid?
      value >= VALID_AGE_START && value <= VALID_AGE_END
    end
  end
end

module Commands
  class Default
    extend Brigadier

    toggle 'debug', 'Debugging toggle'
    toggle 'verbose', 'Verbose mode', default: true
    argument 'name', 'Name of person'

    execute do
      puts "Inside \#execute: name: #{name}, debug?: #{debug?}, verbose?: #{verbose?}"
    end
  end
end

module SubCommands
  class GuestAndAdmin
    extend Brigadier

    DAYS_IN_A_YEAR = 365

    toggle 'debug', 'Debugging'

    sub_command 'guest', 'Guest sub command' do
      argument 'name', 'Name of guest', validators: [ CustomValidations::AntiPooper ]

      execute do
        puts "Inside guest sub command's \#execute: name: #{name} debug?: #{debug?}"
      end
    end

    sub_command 'admin', 'Admin sub command' do
      toggle 'important', 'Important'
      toggle 'sensitive', 'Sensitive', default: true

      argument 'name', 'Name of admin', validators: [ CustomValidations::AntiPooper ]
      argument 'email', 'Email of admin', validators: [ Brigadier::Validators::Email ]

      option 'age', 'Age', default: 25, validators: [ CustomValidations::SensibleAge ] { |age| age.to_i }

      def age_in_days
        age * DAYS_IN_A_YEAR
      end

      execute do
        puts <<-EOS
Inside admin sub command's \#execute:
  name: #{name}
  email: #{email}
  age: #{age}
  age in days: #{age_in_days}
  debug?: #{debug?}
  important?: #{important?}
  sensitive?: #{sensitive?}
EOS
      end
    end
  end
end

Brigadier::Runner.new(ARGV).run(Commands::Default, SubCommands::GuestAndAdmin)
