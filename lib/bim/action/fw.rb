module Bim
  module Action
    # Fw class uses by Bim::Subcommands::Fw
    class Fw
      extend Bim::Util

      FW_PATH = '/mgmt/tm/security/firewall/policy'.freeze
      FW_URI = URI.join(Bim::BASE_URL, Bim::Action::Fw::FW_PATH)

      DETAIL_CONF = {
        name: 'firewall_policy',
        items: false,
        attrs: %w[name fullPath],
        under_key: 'rulesReference',
        under_layer: {
          name: 'rules_reference',
          items: true,
          attrs: %w[name description ipProtocol ruleList],
          under_key: 'ruleListReference',
          under_layer: {
            name: 'rule_list_reference',
            items: false,
            attrs: %w[name fullPath],
            under_key: 'rulesReference',
            under_layer: {
              name: 'rules_reference',
              items: true,
              attrs: %w[name description destination source]
            }
          }
        }
      }.freeze

      class << self
        def ls
          map(FW_URI) do |item|
            { 'item' => item['name'], 'fullPath' => item['fullPath'] }
          end
        end

        def detail(name)
          start_uri = URI(sub_localhost(specify_link_by_name(FW_URI, name)))
          detail_depth(start_uri, DETAIL_CONF).to_json
        end

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
          proc do |data, conf, map = false|
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
