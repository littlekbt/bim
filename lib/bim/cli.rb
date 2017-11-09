require 'thor'
require 'bim/subcommands'

module Bim
  # CLI class is import subcommands
  class CLI < Thor
    # define under subcommands files as subcommands
    Dir.glob(::Pathname.new(__dir__) + 'subcommands/*').map{|fp| File.basename(fp).split('.rb')[0]}.each do |cmd|
      klass = Object.const_get("Bim").const_get("Subcommands").const_get(cmd.capitalize)
      desc "#{cmd} [Subcommand]", "Subcommands: #{klass.instance_methods(false).join(',')}"
      subcommand cmd, klass
    end
  end
end
