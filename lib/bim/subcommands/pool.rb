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
        'create [NAME] [MEMBERS(optional: \'[{"name": "NodeName:Port", "address": "NodeAddress"}, {"name": "NodeName:Port", "address": "NodeAddress"}]\')]',
        'create pool with node members'
      )
      def create(name, members = nil)
        puts Bim::Action::Pool.create(name, members)
      end

      desc(
        'members [NAME]',
        'output members belongs to pool'
      )
      def members(name)
        puts Bim::Action::Pool.members(name)
      end

      desc(
        'drop [NAME] [MEMBERS(NodeName:Port)]',
        'drop node members (members are variable length)'
      )
      def drop(name, *members)
        puts Bim::Action::Pool.drop_members(name, members)
      end

      desc(
        'add [NAME] [MEMBERS(NodeName:Port)]',
        'add node members (members aer variable length)'
      )
      def add(name, *members)
        puts Bim::Action::Pool.add_members(name, members)
      end
    end
  end
end
