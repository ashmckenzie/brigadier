module Brigadier
  module Parameters
    class Toggle
      include Base

      def initialize(name, description, args, block)
        @name = name
        @description = description
        @args = args
        @block = block
        @value = default_value
        assign_value_from_env_variable
      end

      def display_name
        "--#{name}"
      end

      def display_description
        '%s (%s)' % [ description, description_detail ]
      end

      def enable!
        assign_value(true)
      end

      def disable!
        assign_value(false)
      end

      private

        attr_reader :args

        def value_set?
          value != default_value
        end

        def description_detail
          detail = [ 'default: %s' % [ default_value ] ]
          detail << 'current: %s' % [ value ] if value_set?
          detail.join(', ')
        end

        def aliases
          args.fetch(:aliases, [])
        end

        def klass_only
          self.class.to_s.to_s.gsub(/^.*::/, '')
        end

        def default_value
          args.fetch(:default, false)
        end

        def assign_value(value)
          @value = value
          ENV[env_variable_value_key_name] = value.to_s.downcase
        end
    end
  end
end
