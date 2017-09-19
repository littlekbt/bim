module Bim
  module Action
    # Meta class uses by Bim::Subcommands::Meta
    class Meta
      extend Bim::Util

      DEVICE_PATH = '/mgmt/tm/cm/device'.freeze
      DEVICE_GROUP_PATH = '/mgmt/tm/cm/deviceGroup'.freeze

      class << self
        def actives
          uri = URI.join(Bim::BASE_URL, Bim::Action::Meta::DEVICE_PATH)
          JSON
            .parse(get_body(uri))['items']
            .select { |item| item['failoverState'] == 'active' }
            .inject([]) do |infos, item|
              infos.push(hostname: item['hostname'], ip: item['managementIp'])
            end.to_json
        end

        def device_groups
          uri = URI.join(Bim::BASE_URL, Bim::Action::Meta::DEVICE_GROUP_PATH)
          JSON
            .parse(get_body(uri))['items']
            .select { |item| item['type'] == 'sync-failover' }
            .inject([]) do |infos, item|
              m = if item&.dig('devicesReference')&.dig('link')
                    uri_r = URI.parse(item['devicesReference']['link'].sub('localhost', BIGIP_HOST))
                    JSON.parse(get_body(uri_r))['items'].map { |item_in| item_in['name'] }
                  end
              infos.push(name: item['name'], members: m)
            end.to_json
        end
      end
    end
  end
end
