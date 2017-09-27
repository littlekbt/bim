module Bim
  module Action
    # Sync class used by Bim::Subcommands::Sync
    class Sync
      extend Bim::Util

      SYNC_PATH = '/mgmt/tm/cm'.freeze
      SYNC_STATE_PATH = '/mgmt/tm/cm/syncStatus'.freeze
      FAILOVER_STATE_PATH = '/mgmt/tm/cm/failoverStatus'.freeze

      class << self
        def sync!(dest, overwrite: false)
          msg = "you want to sync #{BIGIP_HOST} configuration to #{dest}? [y|n]"
          return { 'message' => "cancel sync #{BIGIP_HOST} to #{dest}" } unless yes_or_no?(msg)
          uri = URI.join(Bim::BASE_URL, Bim::Action::Sync::SYNC_PATH)
          j = { "command": 'run', "utilCmdArgs": "config-sync #{'force-full-load-push ' if overwrite}to-group #{dest}" }
          req = request(uri, Bim::AUTH, 'application/json', 'POST', j.to_json)
          http(uri).request(req).body
        end

        def state
          uri = URI.join(Bim::BASE_URL, Bim::Action::Sync::SYNC_STATE_PATH)
          req = request(uri, Bim::AUTH, 'application/json')
          res = http(uri).request(req)
          body = JSON.parse(res.body)
          body['entries'].each_with_object({}) do |(_key, value), info|
            entries = value['nestedStats']['entries']
            info['color']   = entries['color']['description']
            info['summary'] = entries['summary']['description']
          end.to_json
        end

        def failover_state
          uri = URI.join(Bim::BASE_URL, Bim::Action::Sync::FAILOVER_STATE_PATH)
          req = request(uri, Bim::AUTH, 'application/json')
          body = JSON.parse(http(uri).request(req).body)
          body['entries'].each_with_object({}) do |(_key, value), info|
            entries = value['nestedStats']['entries']
            info['color']   = entries['color']['description']
            info['summary'] = entries['summary']['description']
            info['status']  = entries['status']['description']
          end.to_json
        end
      end
    end
  end
end
