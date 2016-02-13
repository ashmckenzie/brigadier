module Brigadier
  module Parameters
    class Argument
      include Base

      def initialize(name, description, args, block)
        @name = name
        @description = description
        @args = args
        @value = nil
        @block = block
        assign_value_from_env_variable
      end

      def display_name
        name
      end

      def display_description
        opts = []
        opts << 'valid_values: %s' % [ valid_values.inspect ] if valid_values?
        opts << 'current: %s' % [ value.inspect ]

        if opts.empty?
          '%s' % [ description ]
        else
          '%s (%s)' % [ description, opts.join(', ') ]
        end
      end

      def valid_values
        args.fetch(:valid_values, [])
      end

      def validate!
        validate_presence!    if required?
        validate_valid_value! if valid_values?
        validate_using_klass! if validator_klasses
      end

      def required?
        true
      end

      def valid_values?
        !valid_values.empty?
      end

      private

        attr_reader :args

        def validate_valid_value!
          raise Exceptions::ValueInvalid.new(self), 'Value is invalid.  Valid values are %s' % [ valid_values] if valid_values? && !valid_values.include?(value)
        end

        def validate_presence!
          raise Exceptions::ValueMissing.new(self), 'Value is empty' if [ nil, '' ].include?(value)
        end
    end
  end
end
