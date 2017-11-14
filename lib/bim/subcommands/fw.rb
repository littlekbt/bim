module Bim
  module Subcommands
    # Fw class defines subcommands
    class Fw < Thor
      desc(
        'ls',
        'output firewall policy list'
      )
      def ls
        puts Bim::Action::Fw.ls
      end

      desc(
        'detail [NAME]',
        'output firewall policy detail'
      )
      def detail(name)
        puts Bim::Action::Fw.detail(name)
      end
    end
  end
end
