module Bim
  module Action
    # Node class uses by Bim::Subcommands::Node
    class Pool
      extend Bim::Util

      POOL_PATH = '/mgmt/tm/ltm/pool'.freeze
      POOL_URI = URI.join(Bim::BASE_URL, Bim::Action::Pool::POOL_PATH)

      class << self
        def ls
          map(POOL_URI) do |item|
            r = { name: item['name'] }
            r['members'] = JSON.parse(map(URI(sub_localhost(item['membersReference']['link']))) do |in_item|
              { name: in_item['name'], address: in_item['address'] }
            end)
            r
          end
        end

        def create(name, monitor, slow_ramp_time, members)
          j = { 'name' => name, 'monitor' => monitor, 'slowRampTime' => slow_ramp_time }
          j['members'] = JSON.parse(members.delete('\\')) unless members.nil?
          post(POOL_URI, j.to_json)
        end

        def update(name, monitor, slow_ramp_time, members)
          uri = URI(sub_localhost(specify_link_by_name(POOL_URI, name)))
          j = { 'name' => name, 'monitor' => monitor, 'slowRampTime' => slow_ramp_time }
          j['members'] = JSON.parse(members.delete('\\')) unless members.nil?
          req = request(uri, Bim::AUTH, 'application/json', 'PATCH', j.to_json)
          http(uri).request(req).body
        end

        def members(name)
          cond = proc { |item| name == item['name'] }
          select_map(POOL_URI, cond) do |item|
            JSON.parse(map(URI(sub_localhost(item['membersReference']['link']))) do |in_item|
              { name: in_item['name'], address: in_item['address'] }
            end)
          end
        end

        def enable(name, members)
          { 'enabled_members': change_session(name, members, 'user-enabled') }
        end

        def disable(name, members)
          { 'disabled_members': change_session(name, members, 'user-disabled') }
        end

        def drop_members(name, members)
          members_link = specify_link(POOL_URI, %w[membersReference link]) do |item|
            item['name'] == name
          end

          drop_members = []

          cond = proc { |item| members.include?(item['name']) }
          JSON.parse(select_map(URI(sub_localhost(members_link)), cond) do |item|
            { 'name': item['name'], 'self_link': sub_localhost(item['selfLink']) }
          end).each do |item|
            next unless yes_or_no?("drop #{item['name']} from #{name}? [y|n]")
            uri = URI.parse(item['self_link'])
            req = request(uri, Bim::AUTH, 'application/json', 'DELETE')
            drop_members.push(item['name']) if http(uri).request(req).code == '200'
          end

          { 'drop_members': drop_members }
        end

        def add_members(name, members)
          members_link = specify_link(POOL_URI, %w[membersReference link]) do |item|
            item['name'] == name
          end

          add_members = []

          members.each do |member|
            if post(URI(sub_localhost(members_link)), { 'name': member }.to_json, false).code == '200'
              add_members.push(member)
            end
          end

          { 'add_members': add_members }
        end

        private

        def change_session(name, members, session_value)
          uri = URI(sub_localhost(specify_link_by_name(POOL_URI, name, %w[membersReference link])))

          success_members = []
          cond = proc { |item| members.include?(item['name']) }
          JSON.parse(select_map(uri, cond) do |item|
            { 'name': item['name'], 'self_link': sub_localhost(item['selfLink']) }
          end).each do |item|
            uri = URI.parse(item['self_link'])
            req = request(uri, Bim::AUTH, 'application/json', 'PATCH', { session: session_value }.to_json)
            success_members.push(item['name']) if http(uri).request(req).code == '200'
          end

          success_members
        end
      end
    end
  end
end
