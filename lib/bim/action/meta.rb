module Bim
  module Action
    # Meta class uses by Bim::Subcommands::Meta
    class Meta
      extend Bim::Util

      DEVICE_PATH = '/mgmt/tm/cm/device'.freeze
      DEVICE_GROUP_PATH = '/mgmt/tm/cm/deviceGroup'.freeze

      class << self
        def actives
          cond = Proc.new { |item| item['failoverState'] == 'active' }
          select_map(URI.join(Bim::BASE_URL, Bim::Action::Meta::DEVICE_PATH), cond) do |item|
            { hostname: item['hostname'], ip: item['managementIp'] }
          end
        end

        def device_groups
          cond = Proc.new { |item| item['type'] == 'sync-failover' }
          select_map(URI.join(Bim::BASE_URL, Bim::Action::Meta::DEVICE_GROUP_PATH), cond) do |item|
            m = if item&.dig('devicesReference')&.dig('link')
                    uri_r = URI.parse(item['devicesReference']['link'].sub('localhost', BIGIP_HOST))
                    JSON.parse(get_body(uri_r))['items'].map { |item_in| item_in['name'] }
                end
            { name: item['name'], members: m }
          end
        end
      end
    end
  end
end
