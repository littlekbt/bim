module Bim
  module Subcommands
    # Meta class defines subcommands
    class Meta < Thor
      desc(
        'actives',
        'output active hosts'
      )
      def actives
        puts Bim::Action::Meta.actives
      end

      desc(
        'device_groups',
        'output device groups'
      )
      def device_groups
        puts Bim::Action::Meta.device_groups
      end
    end
  end
end
