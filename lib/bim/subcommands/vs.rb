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
        'update_dnat [NAME] [DNAT_ADDRESS] [PORT]',
        'update dnat configuration'
      )
      def update_dnat(name, dnat_addr, port)
        puts Bim::Action::VS.update_dnat(name, dnat_addr, port)
      end

      desc(
        'update_snat [NAME] [SNAT_ADDRESS] [BIT_MASK]',
        'update snat configuration'
      )
      def update_snat(name, snat_addr, bit_mask)
        puts Bim::Action::VS.update_snat(name, snat_addr, bit_mask)
      end

      desc(
        'change_nf [VS_NAME] [NETWORK_FIREWALL_NAME]',
        'change network firewall policy'
      )
      def change_nf(name, nf_name)
        puts Bim::Action::VS.change_nf(name, nf_name)
      end

      desc(
        'change_pool [NAME] [POOL_NAME]',
        'change pool'
      )
      def change_pool(name, pool_name)
        puts Bim::Action::VS.change_pool(name, pool_name)
      end
    end
  end
end
