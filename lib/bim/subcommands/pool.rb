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
        'create [NAME]',
        'create pool with node members'
      )
      option :monitor, desc: 'monitor expects string(ex: \'http\', \'http and https\')'
      option :slow_ramp_time, desc: 'slow_ramp_time expects integer'
      option :members, desc: 'members expects json array(members: \'[{"name": "NodeName:Port", "address": "NodeAddress"}, {"name": "NodeName:Port", "address": "NodeAddress"}]\')'
      def create(name)
        puts Bim::Action::Pool.create(name, options[:monitor], options[:slow_ramp_time], options[:members])
      end

      desc(
        'update [NAME]',
        'update pool with node members'
      )
      option :monitor, desc: 'monitor expects string(ex: \'http\', \'http and https\')'
      option :slow_ramp_time, desc: 'slow_ramp_time expects integer'
      option :members, desc: 'members expects json array(members: \'[{"name": "NodeName:Port", "address": "NodeAddress"}, {"name": "NodeName:Port", "address": "NodeAddress"}]\')'
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
        'enable [NAME]',
        'enable node members'
      )
      option :members, required: true, type: :array, desc: 'members expects NodeName:Port format'
      def enable(name)
        puts Bim::Action::Pool.enable(name, options[:members])
      end

      desc(
        'disable [NAME]',
        'disable node members'
      )
      option :members, required: true, type: :array, desc: 'members expects NodeName:Port format'
      def disable(name)
        puts Bim::Action::Pool.disable(name, options[:members])
      end

      desc(
        'add [NAME]',
        'add node members'
      )
      option :members, required: true, type: :array, desc: 'members expects NodeName:Port format'
      def add(name)
        puts Bim::Action::Pool.add_members(name, options[:members])
      end

      desc(
        'drop [NAME]',
        'drop node members'
      )
      option :members, required: true, type: :array, desc: 'members expects NodeName:Port format'
      def drop(name)
        puts Bim::Action::Pool.drop_members(name, options[:members])
      end
    end
  end
end
