module Brigadier
  module Commands
    module Base
      include Helper

      def process_args(args, obj)
        args_to_keep = []
        until args.empty?
          arg = args.shift
          if option_or_toggle?(arg)
            next if set_options_for(arg, args, obj.options) || set_toggles_for(arg, obj.toggles)
          elsif set_argument_for(arg, obj.arguments)
            next
          end
        end
        args = args_to_keep
      end

      def sub_command?
        false
      end

      def hidden?
        false
      end

      def assign_toggles_from(toggles)
        toggles.each do |toggle|
          name = toggle.normalised_attribute_name.to_sym
          method_name = "#{name}?"
          instance.instance_variable_set(:"@#{name}", toggle.value)
          $stderr.puts "WARN: Overwrting existing method '#{name}'.." if instance.respond_to?(name)
          instance.define_singleton_method(method_name) { toggle.value }
        end
      end

      def assign_options_from(parameters)
        create_variable_and_method_from(parameters)
      end

      def assign_arguments_from(parameters)
        create_variable_and_method_from(parameters)
      end

      def create_variable_and_method_from(parameters)
        parameters.each do |param|
          name = param.normalised_attribute_name.to_sym
          instance.instance_variable_set(:"@#{name}", param.value)
          $stderr.puts "WARN: Overwrting existing method '#{name}'.." if instance.respond_to?(name)
          instance.define_singleton_method(name) { param.value }
        end
      end

      def ensure_parameters_defined!(*parameters)
        captured_errors = validate_parameters!(parameters)
        unless captured_errors.empty?
          captured_errors.each { |e| $stderr.puts "ERROR: #{e}" }
          exit(Exceptions::ERROR_EXIT_CODE)
        end
      end

      private

        def validate_parameters!(parameters)
          captured_errors = []
          parameters.flatten.each do |parameter|
            begin
              parameter.validate!
            rescue Exceptions::Base => e
              captured_errors << e.as_str
            end
          end
          captured_errors
        end

        def set_toggles_for(arg, obj)
          obj.each do |names, toggle|
            next unless names.include?(arg)
            action = inverse_toggle_arg?(arg) ? :disable! : :enable!
            toggle.public_send(action)
            return true
          end
          false
        end

        def set_options_for(arg, args, obj)
          obj.each do |names, option|
            next unless names.include?(arg)
            option.value = args.shift
            return true
          end
          false
        end

        def set_argument_for(value, obj)
          obj.each do |_, argument|
            next if argument.value
            argument.value = value
            return true
          end
          false
        end

        def available_toggles
          klass.toggles.values.uniq(&:name)
        end

        def available_options
          klass.options.values.uniq(&:name)
        end

        def available_arguments
          klass.arguments.values.uniq(&:name)
        end
    end
  end
end
