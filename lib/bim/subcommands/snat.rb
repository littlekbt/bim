module Bim
  module Subcommands
    # Snat class defines subcommands
    class Snat < Thor
      desc(
        'ls',
        'output snat list'
      )
      def ls
        puts Bim::Action::Snat.ls
      end

      desc(
        'detail [NAME]',
        'output SNAT detail configuration'
      )
      def detail(name)
        puts Bim::Action::Snat.detail(name)
      end

      desc(
        'create [NAME] [--translation=IPADDR] [--address_list=IPADDR/Mask IPADDR/Mask] [--vlans=VLAN1 VLAN2]',
        'create SNAT'
      )
      option :vlans, type: :array
      option :translation, required: true
      option :address_list, required: true, type: :array
      def create(name)
        puts Bim::Action::Snat.create(name, options[:translation], options[:address_list], options[:vlans])
      end

      desc(
        'update [NAME] [--translation=IPADDR] [--address_list=IPADDR/Mask IPADDR/Mask] [--vlans=VLAN1 VLAN2]',
        'update SNAT'
      )
      option :vlans, type: :array
      option :translation, required: true
      option :address_list, required: true, type: :array
      def update(name)
        puts Bim::Action::Snat.update(name, options[:translation], options[:address_list], options[:vlans])
      end

      desc(
        'add_address [NAME] [ADDRESSES(Address/Mask)]',
        'add address for SNAT (ADDRESSES are variable length)'
      )
      def add_address(name, *addresses)
        puts Bim::Action::Snat.add_address(name, addresses)
      end

      desc(
        'remove_address [NAME] [ADDRESSES]',
        'remove address for SNAT (ADDRESSES are variable length)'
      )
      def remove_address(name, *addresses)
        puts Bim::Action::Snat.remove_address(name, addresses)
      end
    end
  end
end
