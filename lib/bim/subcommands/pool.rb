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
        'output members belongs pool'
      )
      def members(name)
        puts Bim::Action::Pool.members(name)
      end

      desc(
        'enable [NAME] [--members=NodeName:Port NodeName:Port]',
        'enable node members (members are variable length)'
      )
      option :members, required: true, type: :array
      def enable(name)
        puts Bim::Action::Pool.enable(name, options[:members])
      end

      desc(
        'disable [NAME] [--members=NodeName:Port NodeName:Port]',
        'disable node members (members are variable length)'
      )
      option :members, required: true, type: :array
      def disable(name)
        puts Bim::Action::Pool.disable(name, options[:members])
      end

      desc(
        'add [NAME] [--members=NodeName:Port NodeName:Port]',
        'add node members (members aer variable length)'
      )
      option :members, required: true, type: :array
      def add(name)
        puts Bim::Action::Pool.add_members(name, options[:members])
      end

      desc(
        'drop [NAME] [--members=NodeName:Port NodeName:Port]',
        'drop node members (members are variable length)'
      )
      option :members, required: true, type: :array
      def drop(name)
        puts Bim::Action::Pool.drop_members(name, options[:members])
      end
    end
  end
end
