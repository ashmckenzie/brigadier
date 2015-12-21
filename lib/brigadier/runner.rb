require 'ostruct'

module Brigadier
  class Runner
    include Helper

    def initialize(args)
      @args = args
    end

    def run(*klasses)
      remaining_args = []
      args_to_process = []
      sub_command_to_execute = false
      full_args = args.dup

      collect_execute_blocks(klasses)

      klasses.each do |klass|
        remaining_args = args.dup

        until remaining_args.empty?
          arg = remaining_args.shift

          klass.sub_commands.each do |names, sub_command|
            next unless names.include?(arg)
            sub_command_to_execute = sub_command
            break
          end

          break if sub_command_to_execute

          args_to_process << arg
        end

        break if sub_command_to_execute
      end

      if sub_command_to_execute
        args_to_process += remaining_args
        sub_command_to_execute.execute(args_to_process, full_args)
      elsif default_command
        default_command.execute(args, full_args, klasses)
      elsif help_requested?(args)
        $stderr.puts
        help(klasses)
      else
        raise Exceptions::ExecuteBlockMissing.new(self), 'There is no execute {} block defined'
      end
    rescue Exceptions::ExecuteBlockMissing, Exceptions::Base => e
      $stderr.puts "ERROR: #{e.message}"
      exit(Exceptions::ERROR_EXIT_CODE)
    end

    private

      attr_reader :args

      def default_command
        Brigadier.default_command
      end

      def collect_execute_blocks(klasses)
        klasses.each do |klass|
          execute_proc = klass.instance_variable_get('@execute_proc')
          next unless execute_proc
          Brigadier.set_default_command(klass, execute_proc)
        end
      end
  end
end
