module Bim
  module Action
    # Snat class uses by Bim::Subcommands::Node
    class Snat
      extend Bim::Util

      SNAT_PATH = '/mgmt/tm/ltm/snat'.freeze
      SNAT_URI = URI.join(Bim::BASE_URL, Bim::Action::Snat::SNAT_PATH)

      class << self
        def ls
          map(SNAT_URI) do |item|
            {
              'name': item['name'],
              'translation': item['translation'],
              'address_list': item['origins'].map { |origin| origin['name'] }
            }
          end
        end

        def detail(name)
          specify(SNAT_URI) { |d| d['name'] == name }
        end

        def create(name, translation, address_list, vlans)
          j = {
            'name': name,
            'translation': translation,
            'origins': address_list.map { |address| { 'name': address } }
          }
          unless vlans.nil?
            j['vlansEnabled'] = true
            j['vlans'] = vlans.map { |vlan| "/Common/#{vlan}" }
          end
          post(SNAT_URI, j.to_json)
        end

        def update(name, translation, address_list, vlans)
          j = {}
          if address_list
            j['origins'] = address_list.map { |address| { 'name': address } }
          end
          j['translation'] = translation if translation
          unless vlans.nil?
            j['vlansEnabled'] = true
            j['vlans'] = vlans.map { |vlan| "/Common/#{vlan}" }
          end
          self_patch(name, SNAT_URI, j.to_json)
        end

        def add_address(name, addresses)
          origins = specify_link_by_name(SNAT_URI, name, %(origins))
          j = { 'origins': origins.push(addresses.map { |address| { 'name': address } }).flatten }
          self_patch(name, SNAT_URI, j.to_json)
        end

        def remove_address(name, addresses)
          origins = specify_link_by_name(SNAT_URI, name, %(origins))
          j = { 'origins': (origins.map { |origin| origin['name'] } - addresses).map { |address| { 'name': address } } }
          self_patch(name, SNAT_URI, j.to_json)
        end
      end
    end
  end
end
