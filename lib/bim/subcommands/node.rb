module Bim
  module Subcommands
    # Node class defines subcommands
    class Node < Thor
      desc(
        'ls',
        'output node list'
      )
      def ls
        puts Bim::Action::Node.ls
      end

      desc(
        'detail [NAME]',
        'output node detail'
      )
      def detail(name)
        puts Bim::Action::Node.detail(name)
      end

      desc(
        'create [NAME] [ADDRESS]',
        'create node'
      )
      def create(name, address)
        puts Bim::Action::Node.create(name, address)
      end

      desc(
        'delete [NAME]',
        'delete node'
      )
      def delete(name)
        puts Bim::Action::Node.delete(name)
      end
    end
  end
end
