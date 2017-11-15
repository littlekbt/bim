module Bim
  module Subcommands
    # Vs class defines subcommands
    class Vs < Thor
      desc(
        'ls',
        'output virtual server info list'
      )
      def ls
        puts Bim::Action::VS.ls
      end

      desc(
        'detail [NAME]',
        'output one of virtual server info'
      )
      def detail(name)
        puts Bim::Action::VS.detail(name)
      end

      desc(
        'update_global_address [NAME] [GLOBAL_ADDRESS] [PORT]',
        'update global ip address'
      )
      def update_global_address(name, global_addr, port)
        puts Bim::Action::VS.update_global_address(name, global_addr, port)
      end

      desc(
        'change_nf [VS_NAME] [NETWORK_FIREWALL_FULLPATH]',
        'change network firewall policy'
      )
      def change_nf(name, nf_name)
        puts Bim::Action::VS.change_nf(name, nf_name)
      end

      desc(
        'change_pool [NAME] [POOL_FULLPATH]',
        'change pool'
      )
      def change_pool(name, pool_name)
        puts Bim::Action::VS.change_pool(name, pool_name)
      end
    end
  end
end
