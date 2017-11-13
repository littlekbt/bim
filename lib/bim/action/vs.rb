module Bim
  module Action
    # VS class used by Bim::Subcommands::VS
    class VS
      extend Bim::Util

      VS_PATH = '/mgmt/tm/ltm/virtual'.freeze
      VS_URI = URI.join(Bim::BASE_URL, Bim::Action::VS::VS_PATH)

      class << self
        def ls
          map(VS_URI) do |item|
            r = { name: item['name'] }
            r['profiles'] = JSON.parse(map(URI(sub_localhost(item['profilesReference']['link']))) do |in_item|
              in_item['fullPath']
            end)
            r
          end
        end

        def detail(name)
          specify(VS_URI) { |d| d['name'] == name }
        end

        def update_dnat(name, dnat_addr, port)
          j = {"destination" => "#{dnat_addr}:#{port}"}.to_json
          self_patch(name, VS_URI, j)
        end

        def update_snat(name, snat_addr, bitmask)
          j = {"source" => "#{snat_addr}/#{bitmask}"}.to_json
          self_patch(name, VS_URI, j)
        end

        def change_nf(name, nf_name)
          j = {"fwEnforcedPolicy" => nf_name}.to_json
          self_patch(name, VS_URI, j)
        end

        def change_pool(name, pool_name)
          j = {"pool" => pool_name}.to_json
          self_patch(name, VS_URI, j)
        end
      end
    end
  end
end
