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
        'create [NAME]',
        'create SNAT'
      )
      option :vlans, type: :array
      option :translation, required: true
      option :address_list, required: true, type: :array, desc: 'address_list expects CIDR format(IPADDR/Mask)'
      def create(name)
        puts Bim::Action::Snat.create(name, options[:translation], options[:address_list], options[:vlans])
      end

      desc(
        'update [NAME]',
        'update SNAT'
      )
      option :vlans, type: :array
      option :translation, required: true
      option :address_list, required: true, type: :array, desc: 'address_list expects CIDR format(IPADDR/Mask)'
      def update(name)
        puts Bim::Action::Snat.update(name, options[:translation], options[:address_list], options[:vlans])
      end

      desc(
        'add_address [NAME]',
        'add address for SNAT'
      )
      option :addresses, required: true, type: :array, desc: 'addresses expects CIDR format(IPADDR/Mask)'
      def add_address(name)
        puts Bim::Action::Snat.add_address(name, options[:addresses])
      end

      desc(
        'remove_address [NAME]',
        'remove address for SNAT'
      )
      option :addresses, required: true, type: :array, desc: 'addresses expects CIDR format(IPADDR/Mask)'
      def remove_address(name)
        puts Bim::Action::Snat.remove_address(name, options[:addresses])
      end
    end
  end
end
