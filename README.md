# Brigadier

Brigadier - Take control of your command line

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brigadier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brigadier

## Usage

Add the following to `basic.rb`:

```ruby
#!/usr/bin/env ruby

require 'brigadier'

class BasicCommand
  extend Brigadier

  toggle 'debug', 'Debugging toggle'
  toggle 'verbose', 'Verbose mode', default: true

  execute do
    puts "Inside \#execute - debug?: #{debug?}, verbose?: #{verbose?}"
  end
end

Brigadier::Runner.new(ARGV).run(BasicCommand)
```

Get some help:

```shell
$ ruby basic.rb --help

Toggle(s)
    --debug                      Debugging toggle (default: false)
    --verbose                    Verbose mode (default: true)

$ ruby basic.rb --debug  --help

Toggle(s)
    --debug                      Debugging toggle (default: false, current: true)
    --verbose                    Verbose mode (default: true)
```

Run it:

```shell
$ ruby basic.rb
Inside #execute - debug?: false, verbose?: true

$ ruby basic.rb --debug --not-verbose
Inside #execute - debug?: true, verbose?: false
```

Check out the [examples](./examples) directory for more examples.

## Contributing

1. Fork it ( https://github.com/ashmckenzie/brigadier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run `bundle exec rake test`
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
