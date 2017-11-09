module Bim
  module Action
    # SSL class used by Bim::Subcommands::SSL
    class SSL
      extend Bim::Util

      UPLOAD_PATH  = '/mgmt/shared/file-transfer/uploads/'.freeze
      INSTALL_PATH = {
        key:  '/mgmt/tm/sys/crypto/key',
        crt: '/mgmt/tm/sys/crypto/cert'
      }.freeze
      CREATE_SSL_PROFILE_PATH = '/mgmt/tm/ltm/profile/clientSsl'.freeze
      VS_PATH = '/mgmt/tm/ltm/virtual'.freeze
      CRT_FILES_PATH = '/mgmt/tm/sys/file/sslCert'.freeze
      CRT_PROFILES_PATH = '/mgmt/tm/ltm/profile/client-ssl'.freeze
      CRT_FILES_URI = URI.join(Bim::BASE_URL, Bim::Action::SSL::CRT_FILES_PATH)
      CRT_PROFILES_URI = URI.join(Bim::BASE_URL, Bim::Action::SSL::CRT_PROFILES_PATH)

      class << self
        def bundles
          cond = proc { |item| item['isBundle'] == 'true' }
          select_map(CRT_FILES_URI, cond) do |item|
            { 'name' => item['name'].split('.')[0...-1].join('.') }
          end
        end

        def profiles
          map(CRT_PROFILES_URI) do |item|
            { 'name' => item['name'], 'fullPath' => item['fullPath'], 'key' => item['key'], 'chain' => item['chain'] }
          end
        end

        def detail(profile_name)
          specify(CRT_PROFILES_URI) do |item|
            item['name'] == profile_name || item['fullPath'] == profile_name
          end
        end

        def upload(filepath)
          f = File.read(filepath)
          uri = URI.join(Bim::BASE_URL, Bim::Action::SSL::UPLOAD_PATH, File.basename(filepath))
          req = request(uri, Bim::AUTH, 'application/octet-stream', 'POST', f) do |req_in|
            req_in['Content-Length'] = f.size
            req_in['Content-Range']  = "0-#{f.size - 1}/#{f.size}"
            req_in
          end

          http(uri).request(req).body
        end

        def install(type, crt_name, local_file_path)
          uri = URI.join(Bim::BASE_URL, Bim::Action::SSL::INSTALL_PATH[type.to_sym])
          req = request(
            uri,
            Bim::AUTH,
            'application/json',
            'POST',
            { 'command' => 'install',
              'name' => crt_name,
              'from-local-file' => local_file_path }.to_json
          )

          http(uri).request(req).body
        end

        def create_ssl_profile(profilename, chain)
          uri = URI.join(Bim::BASE_URL, Bim::Action::SSL::CREATE_SSL_PROFILE_PATH)
          j = { 'name' => profilename,
                'ciphers' => 'DEFAULT:!SSLv3',
                'certKeyChain' => [
                  { 'name' => 'default',
                    'key'   => "#{profilename}.key",
                    'cert'  => "#{profilename}.crt",
                    'chain' => "#{chain}.crt" }
                ] }.to_json

          req = request(uri, Bim::AUTH, 'application/json', 'POST', j)

          http(uri).request(req).body
        end

        # rubocop:disable Metrics/AbcSize
        def replace(old_profilename, new_profilename, test = nil)
          result = { target_vs: [], change_vs: [], fail_vs: [] }
          JSON.parse(vs_list)['items'].each do |vs|
            next if test && vs['name'] != Bim::TEST_VS

            names = JSON.parse(profiles_items(vs['profilesReference']['link']))['items'].map { |p| p['name'] }

            next unless names.include?(old_profilename)
            # can not update only diff.
            old_names = names.map { |name| "/Common/#{name}" }
            names.delete(old_profilename) && names.push(new_profilename)
            names = names.map { |name| "/Common/#{name}" }

            next unless yes_or_no?(output_msg(vs['name'], old_names, names))

            result[:target_vs] << vs['name']
            res = update_profiles(vs['selfLink'], names)
            res.code == '200' ? result[:change_vs] << vs['name'] : result[:fail_vs] << vs['name']
          end
          result.to_json
        end

        private

        def profiles_items(link)
          uri = URI.parse(link.sub('localhost', BIGIP_HOST))
          get_body(uri)
        end

        def update_profiles(link, names)
          uri = URI.parse(link.sub('localhost', BIGIP_HOST))
          post(uri, { profiles: names }.to_json)
        end

        def output_msg(vs_name, old_names, new_names)
          puts <<~MSG
            virtual server: #{vs_name}
            replace #{old_names} to #{new_names}
            diff:
              --: #{(old_names - new_names)}
              ++: #{(new_names - old_names)}
MSG
          print 'is it ok? [y|n]: '
        end
      end
    end
  end
end
