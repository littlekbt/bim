module Bim
  module Subcommands
    # Pool class defines subcommands
    class Pool < Thor
      desc(
        'ls',
        'output pool list'
      )
      def ls
        puts Bim::Action::Pool.ls
      end

      desc(
        'create [name] [members(optional: \'[{"name": "NodeName:Port", "address": "NodeAddress"}, {"name": "NodeName:Port", "address": "NodeAddress"}]\')]',
        'create pool with node members'
      )
      def create(name, members = nil)
        puts Bim::Action::Pool.create(name, members)
      end

      desc(
        'members',
        'output members belongs to pool'
      )
      def members(name)
        puts Bim::Action::Pool.members(name)
      end

      desc(
        'drop name members(NodeName:Port)',
        'drop node members (members are variable length)'
      )
      def drop(name, *members)
        puts Bim::Action::Pool.drop_members(name, members)
      end

      desc(
        'add name members(NodeName:Port)',
        'add node members (members aer variable length)'
      )
      def add(name, *members)
        puts Bim::Action::Pool.add_members(name, members)
      end
    end
  end
end
