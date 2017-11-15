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
      option :monitor
      option :slow_ramp_time
      option :members
      def create(name)
        puts Bim::Action::Pool.create(name, options[:monitor], options[:slow_ramp_time], options[:members])
      end

      desc(
        'update [NAME] [MEMBERS(optional: \'[{"name": "NodeName:Port", "address": "NodeAddress"}, {"name": "NodeName:Port", "address": "NodeAddress"}]\')]',
        'update pool configration'
      )
      option :monitor
      option :slow_ramp_time
      option :members
      def update(name)
        puts Bim::Action::Pool.update(name, options[:monitor], options[:slow_ramp_time], options[:members])
      end

      desc(
        'members [NAME]',
        'output members belongs to pool'
      )
      def members(name)
        puts Bim::Action::Pool.members(name)
      end

      desc(
        'enable [NAME] [MEMBERS(NodeName:Port)]',
        'enable node members (members are variable length)'
      )
      def enable(name, *members)
        puts Bim::Action::Pool.enable(name, members)
      end

      desc(
        'disable [NAME] [MEMBERS(NodeName:Port)]',
        'disable node members (members are variable length)'
      )
      def disable(name, *members)
        puts Bim::Action::Pool.disable(name, members)
      end

      desc(
        'update_health_check ',
        'update health check configuration'
      )
      def update_health_check; end

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
