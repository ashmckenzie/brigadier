module Brigadier
  module Parameters
    module Base
      attr_reader :name, :description, :value

      def forbidden_parameters
        [ :name, :description, :value ]
      end

      def value=(value)
        @value = block_defined? ? block.call(value) : value
        ENV[env_variable_value_key_name] = @value.to_s
      end

      def normalised_attribute_name
        attribute_name.gsub(/[ -]/, '_')
      end

      def attribute_name
        @attribute_name ||= args.fetch(:attribute_name, name).to_s
      end

      def hidden?
        args.fetch(:hidden, false)
      end

      def value?
        !value.nil?
      end

      def valid?
        validate! && true
      rescue Exceptions::Base
        false
      end

      def required?
        args.fetch(:required, false)
      end

      def block_defined?
        !block.nil?
      end

      private

        attr_reader :block

        def default_value
          nil
        end

        def validate_using_klass!
          validator_klasses.each { |klass| klass.new(self).validate! }
        end

        def validator_klasses
          args.fetch(:validators, nil)
        end

        def assign_value_from_env_variable
          value = ENV.fetch(env_variable_value_key_name, default_value)
          @value = value if value
        end

        def normalised_name
          name.gsub(/[ -]/, '_')
        end

        def env_variable_value_key_name
          normalised_name.upcase
        end
    end
  end
end
