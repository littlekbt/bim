module Bim
  module Subcommands
    # VS class defines subcommands
    class VS < Thor
      desc(
        'list',
        'output virtual server info list'
      )
      def list
        puts Bim::Action::VS.list
      end

      desc(
        'detail [NAME]',
        'output one of virtual server info'
      )
      def detail(name)
        puts Bim::Action::VS.detail(name)
      end
    end
  end
end
