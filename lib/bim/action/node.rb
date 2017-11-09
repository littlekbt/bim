module Bim
  module Action
    # Node class uses by Bim::Subcommands::Node
    class Node
      extend Bim::Util

      NODE_PATH = '/mgmt/tm/ltm/node'.freeze

      class << self
        def ls
          uri = URI.join(Bim::BASE_URL, Bim::Action::Node::NODE_PATH)
          JSON
            .parse(get_body(uri))['items']
            .inject([]) do |infos, item|
              infos.push(name: item['name'], address: item['address'])
            end.to_json
        end

        def detail(name)
          uri = URI.join(Bim::BASE_URL, Bim::Action::Node::NODE_PATH)
          JSON
            .parse(get_body(uri))['items']
            .select{|d| d['name'] == name}
            .first
            .to_json
        end

        def create(name, address)
          uri = URI.join(Bim::BASE_URL, Bim::Action::Node::NODE_PATH)
          j = {'name' => name,
               'address' => address,
              }.to_json

          req = request(uri, Bim::AUTH, 'application/json', 'POST', j)

          http(uri).request(req).body
        end

        def delete(name)
          self_link = JSON.parse(detail(name))&.fetch('selfLink')
          return "not found #{name} node" if self_link.nil?
          msg = "you want to delete #{name} node? [y|n]"
          return "cancel delete #{name} node" unless yes_or_no?(msg)
          uri = URI(self_link.sub('localhost', Bim::BIGIP_HOST))
          req = request(uri, Bim::AUTH, 'application/json', 'DELETE')
          msg = http(uri).request(req).body
          msg.empty? ? "success delete #{name} node" : msg
        end
      end
    end
  end
end
