require 'brigadier/version'
require 'brigadier/exceptions'
require 'brigadier/validators'
require 'brigadier/helper'
require 'brigadier/parameters'
require 'brigadier/commands'
require 'brigadier/runner'

module Brigadier
  @@arguments = {}
  @@options = {}
  @@toggles = {}
  @@sub_commands = {}
  @@default_command = nil

  class << self
    def arguments
      @@arguments
    end

    def options
      @@options
    end

    def toggles
      @@toggles
    end

    def sub_commands
      @@sub_commands
    end

    def default_command
      @@default_command
    end

    def set_default_command(klass, block)
      @@default_command = Commands::Command.new(klass, block)
    end

    def has_sub_commands?
      !sub_commands.empty?
    end
  end

  def options
    @options ||= {}
  end

  def toggles
    @toggles ||= {}
  end

  def arguments
    @arguments ||= {}
  end

  def sub_commands
    @sub_commands ||= {}
  end

  def has_sub_commands?
    !sub_commands.empty?
  end

  def execute(&block)
    @execute_proc = block
  end

  def sub_command?
    @sub_command || false
  end

  def sub_command(name, description, args = {}, &block)
    @sub_command = true
    instance = args.fetch(:instance, new)
    aliases = args.fetch(:aliases, [])
    all_aliases = ([ *name ] + aliases).uniq
    args[:aliases] = all_aliases

    sub_commands[all_aliases] = Commands::SubCommand.new(name, description, instance, args, block)
  end

  def argument(name, description, args = {}, &block)
    arguments[name] = Parameters::Argument.new(name, description, args, block)
  end

  def option(name, description, args = {}, &block)
    new_aliases = []
    aliases = args.fetch(:aliases, [])

    ([ *name ] + aliases).each do |n|
      new_aliases << "--#{n}"
      new_aliases << "-#{n}"
    end

    new_aliases.uniq!
    args[:aliases] = new_aliases
    options[new_aliases] = Parameters::Option.new(name, description, args, block)
  end

  def toggle(name, description, args = {}, &block)
    new_aliases = []
    new_inverse_aliases = []
    aliases = args.fetch(:aliases, [])
    modifiers = %w( -- - )
    inverse_modifiers = %w( -no- --no- -not- --not- -no_ --no_ -not_ --not_ )

    ([ *name ] + aliases).each do |n|
      alt_name = n.gsub(/[ -]/, '_')

      modifiers.each do |modifier|
        new_aliases << '%s%s' % [ modifier, n]
        new_aliases << '%s%s' % [ modifier, alt_name ]
      end

      inverse_modifiers.each do |modifier|
        new_inverse_aliases << '%s%s' % [ modifier, n]
        new_inverse_aliases << '%s%s' % [ modifier, alt_name ]
      end
    end

    new_aliases.uniq!
    new_inverse_aliases.uniq!
    all_aliases = [ new_aliases + new_inverse_aliases ].uniq.flatten
    args[:aliases] = new_aliases
    args[:inverse_aliases] = new_inverse_aliases

    toggles[all_aliases] = Parameters::Toggle.new(name, description, args, block)
  end
end
