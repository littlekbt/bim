module Bim
  module Action
    # Fw class uses by Bim::Subcommands::Fw
    class Fw
      extend Bim::Util

      FW_PATH = '/mgmt/tm/security/firewall/policy'.freeze
      FW_URI = URI.join(Bim::BASE_URL, Bim::Action::Fw::FW_PATH)

      class << self
        def ls
          map(FW_URI) do |item|
            { 'item' => item['name'], 'fullPath' => item['fullPath'] }
          end
        end

        def detail(name)
          start_uri = URI(sub_localhost(specify_link_by_name(FW_URI, name)))
          conf = {
            name: 'firewall_policy',
            items: false,
            attrs: ['name', 'fullPath'], 
            under_key: 'rulesReference', 
            under_layer: {
              name: 'rules_reference',
              items: true,
              attrs: ['name', 'description', 'ipProtocol', 'ruleList'],
              under_key: 'ruleListReference',
              under_layer: {
                name: 'rule_list_reference',
                items: false, 
                attrs: ['name', 'fullPath'], 
                under_key: 'rulesReference',
                under_layer: {
                  name: 'rules_reference',
                  items: true, 
                  attrs: ['name', 'description', 'destination', 'source']
                }
              }
            }
          }
 
          detail_depth(start_uri, conf).to_json
        end

        # itemsの時は配列、それ以外はhashを返して上の階層が下の階層のキーで保管すればOK
        def detail_depth(uri, conf)
          datas = JSON.parse(get_body(uri))
          if conf[:items]
            datas['items'].map do |data|
              detail_proc.call(data, conf, true)
            end
          else
            detail_proc.call(datas, conf)
          end
        end

        def detail_proc
          Proc.new do |data, conf, map=false|
            d = {}
            conf[:attrs].each { |attr| d[attr] = data[attr] }

            (map ? (next d) : (return d)) unless data.key?(conf[:under_key])
            next_uri = URI(sub_localhost(data[conf[:under_key]]['link']))
            d[conf[:under_key]] = detail_depth(next_uri, conf[:under_layer])
            d
          end
        end
      end
    end
  end
end
