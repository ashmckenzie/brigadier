module Brigadier
  module Commands
    class Command
      include Base

      attr_reader :instance

      def initialize(instance, block)
        @instance = instance
        @block = block
      end

      def execute(args, full_args, klasses)
        process_args(args, instance)

        set_toggles_from(available_toggles)
        set_options_from(available_options)
        set_arguments_from(available_arguments)

        # FIXME
        objs = (full_args.count == 1) ? klasses : klass
        return if display_help_if_requested(objs, full_args)

        ensure_parameters_defined!(available_options, available_arguments)

        instance.instance_eval(&block)
      end

      private

        attr_reader :block

        # FIXME
        def klass
          @klass ||= instance
        end

    end
  end
end
