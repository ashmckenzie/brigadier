module Brigadier
  module Commands
    class SubCommand
      include Base

      attr_reader :name, :description

      def initialize(name, description, instance, args, block)
        @name = name
        @description = description
        @instance = instance
        @args = args
        @block = block
      end

      def display_name
        aliases.join(', ')
      end

      def display_description
        description
      end

      def execute(args, full_args)
        block.call

        process_args(args.dup, klass)

        assign_toggles_from(available_toggles)
        assign_options_from(available_options)
        assign_arguments_from(available_arguments)

        return if display_help_if_requested(klass, full_args)

        ensure_parameters_defined!(available_options, available_arguments)

        if (execute = klass.instance_variable_get('@execute_proc'))
          instance.instance_eval(&execute)
        else
          raise Exceptions::ExecuteBlockMissing.new(self), 'There is no execute {} block defined'
        end
      end

      def sub_command?
        true
      end

      private

        attr_reader :instance, :args, :block

        def aliases
          @aliases ||= args.fetch(:aliases, [])
        end

        # FIXME
        def klass
          @klass ||= instance.class
        end

    end
  end
end
