require 'thor'
require 'bim/subcommands'

module Bim
  # CLI class is import subcommands
  class CLI < Thor
    desc 'meta [Subcommand]', "Subcommands: #{Bim::Subcommands::Meta.instance_methods(false).join(',')}"
    subcommand 'meta', Bim::Subcommands::Meta

    desc 'sync [Subcommand]', "Subcommands: #{Bim::Subcommands::Sync.instance_methods(false).join(',')}"
    subcommand 'sync', Bim::Subcommands::Sync

    desc 'ssl [Subcommand]', "Subcommands: #{Bim::Subcommands::SSL.instance_methods(false).join(',')}"
    subcommand 'ssl', Bim::Subcommands::SSL

    desc 'vs [Subcommand]', "Subcommands: #{Bim::Subcommands::VS.instance_methods(false).join(',')}"
    subcommand 'vs', Bim::Subcommands::VS
  end
end
