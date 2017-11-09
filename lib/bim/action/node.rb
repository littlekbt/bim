module Bim
  module Action
    # Node class uses by Bim::Subcommands::Node
    class Node
      extend Bim::Util

      NODE_PATH = '/mgmt/tm/ltm/node'.freeze
      NODE_URI = URI.join(Bim::BASE_URL, Bim::Action::Node::NODE_PATH)

      class << self
        def ls
          map(NODE_URI) do |item|
            {name: item['name'], address: item['address']}
          end
        end

        def detail(name)
          specify(NODE_URI) { |d| d['name'] == name }
        end

        def create(name, address)
          post(
            NODE_URI,
            {'name' => name, 'address' => address}.to_json
          )
        end

        def delete(name)
          self_link = JSON.parse(detail(name))&.fetch('selfLink')
          return "not found #{name} node" if self_link.nil?
          return "cancel delete #{name} node" unless yes_or_no?("you want to delete #{name} node? [y|n]")

          uri = URI(self_link.sub('localhost', Bim::BIGIP_HOST))
          req = request(uri, Bim::AUTH, 'application/json', 'DELETE')
          msg = http(uri).request(req).body
          msg.empty? ? "success delete #{name} node" : msg
        end
      end
    end
  end
end
