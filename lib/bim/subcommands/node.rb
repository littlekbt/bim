module Bim
  module Subcommands
    # Node class defines subcommands
    class Node < Thor
      desc(
        'ls',
        'node list'
      )
      def ls
        puts Bim::Action::Node.ls
      end

      desc(
        'detail [name]',
        'node detail'
      )
      def detail(name)
        puts Bim::Action::Node.detail(name)
      end

      desc(
        'create [name] [address]',
        'create node'
      )
      def create(name, address)
        puts Bim::Action::Node.create(name, address)
      end

      desc(
        'delete [name]',
        'delete node'
      )
      def delete(name)
        puts Bim::Action::Node.delete(name)
      end
    end
  end
end
