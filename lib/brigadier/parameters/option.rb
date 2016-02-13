module Brigadier
  module Parameters
    class Option
      include Base

      def initialize(name, description, args, block)
        @name = name
        @description = description
        @args = args
        @value = default_value
        @block = block
        assign_value_from_env_variable
      end

      def display_name
        str = [ "--#{name}" ]
        str << (required? ? '<value>' : '[<value>]')
        str.join(' ')
      end

      def display_description
        opts = []
        opts << 'default: %s' % [ default_value ] if default_value
        opts << 'required: %s' % [ required? ]
        opts << 'current: %s' % [ value.inspect ]
        '%s (%s)' % [ description, opts.join(', ') ]
      end

      def validate!
        validate_presence!    if required?
        validate_using_klass! if validator_klasses
      end

      private

        attr_reader :args

        def aliases
          args.fetch(:aliases, [])
        end

        def default_value
          args.fetch(:default, nil)
        end

        def validate_presence!
          raise Exceptions::ValueMissing.new(self), 'Value is empty' if [ nil, '' ].include?(value)
        end
    end
  end
end
