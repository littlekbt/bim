module Bim
  module Subcommands
    # Sync class defines subcommands
    class Sync < Thor
      default_command :to_group

      desc(
        '[GROUP_NAME] [--overwrite]',
        'sync device configuration to group. if set overwrite option, sync force-full-load-push mode.'
      )
      option :overwrite, :type => :boolean
      def to_group(group)
        puts Bim::Action::Sync.sync!(group, overwrite: options.key?(:overwrite))
      end

      desc(
        'state',
        'get sync state'
      )
      def state
        puts Bim::Action::Sync.state
      end

      desc(
        'failover_state',
        'get failover state'
      )
      def failover_state
        puts Bim::Action::Sync.failover_state
      end
    end
  end
end
