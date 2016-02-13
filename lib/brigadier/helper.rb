module Brigadier
  module Helper
    def display_help_for(item, label)
      opts = item.values.uniq(&:name)
      return if opts.empty?
      $stderr.puts label
      opts.each do |opt|
        next if opt.hidden?
        $stderr.puts '%s  %-28s %s' % [ indent, opt.display_name, opt.display_description ]
      end
      $stderr.puts
    end

    def help_requested?(args)
      !(%w( --help -help -h ) & args).empty?
    end

    def display_help_if_requested(klasses, args)
      return false unless help_requested?(args)
      $stderr.puts
      help(klasses)
      true
    end

    def help(klasses)
      klasses = [ *klasses ]
      display_help_for(available_params_for(klasses, :toggles), 'Toggle(s)')
      display_help_for(available_params_for(klasses, :options), 'Option(s)')
      display_help_for(available_params_for(klasses, :arguments), 'Argument(s)')
      display_help_for(available_params_for(klasses, :sub_commands), 'Subcommand(s)') unless sub_command?
    end

    def available_params_for(klasses, param)
      klasses.each_with_object({}) { |k, a| a.merge!(k.public_send(param)) }
    end

    def inverse_toggle_arg?(arg)
      arg =~ /^-{1,}no.+$/ ? true : false
    end

    def sub_command?
      is_a?(Brigadier::Commands::SubCommand)
    end

    def option_or_toggle?(arg)
      arg.match(/^-[-\w+]/)
    end

    private

      def indent
        @indent ||= (' ' * 2)
      end
  end
end
