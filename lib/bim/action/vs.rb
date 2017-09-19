module Bim
  module Action
    # VS class used by Bim::Subcommands::VS
    class VS
      extend Bim::Util

      VIRTUALS_PATH = '/mgmt/tm/ltm/virtual'.freeze

      class << self
        def list
          JSON
            .parse(vs_list)['items']
            .map do |vs|
              profiles = JSON.parse(profiles(vs['profilesReference']['link']))['items'].map { |p| p['fullPath'] }
              { 'name' => vs['name'], 'profiles' => profiles }
            end.to_json
        end

        def detail(name)
          JSON
            .parse(vs_list)['items']
            .select { |vs| vs['name'] == name }
            .map do |vs|
              profiles = JSON.parse(profiles(vs['profilesReference']['link']))['items'].map { |p| p['fullPath'] }
              { 'name' => vs['name'], 'profiles' => profiles }
            end.first.to_json
        end
      end
    end
  end
end
