module Bim
  module Subcommands
    # SSL class defines subcommands
    class SSL < Thor
      desc(
        'bundles',
        'output bundle certificat files info'
      )
      def bundles
        puts Bim::Action::SSL.bundles
      end

      desc(
        'profiles',
        'output SSL Profiles info'
      )
      def profiles
        puts Bim::Action::SSL.profiles
      end

      desc(
        'detail [PROFILE NAME]',
        'output specified SSL Profile info'
      )
      def detail(profile_name)
        puts Bim::Action::SSL.detail(profile_name)
      end

      desc(
        'upload_key [CERTIFICATE_PROFILE_NAME] [PRIVATE_KEYFILE(absolute path)]',
        'upload private key file to bigip local & install to file management'
      )
      def upload_key(crt_name, key_file)
        r = Bim::Action::SSL.upload(key_file)
        puts Bim::Action::SSL.install(:key, crt_name, JSON.parse(r)['localFilePath'])
      end

      desc(
        'upload_crt [CERTIFICATE_PROFILE_NAME] [CERTIFICATE_FILE(absolute path)]',
        'upload certificate file to bigip local & install to file management'
      )
      def upload_crt(crt_name, crt_file)
        r = Bim::Action::SSL.upload(crt_file)
        puts Bim::Action::SSL.install(:crt, crt_name, JSON.parse(r)['localFilePath'])
      end

      desc(
        'upload [CERTIFICATE_PROFILE_NAME] [PRIVATE_KEYFILE(absolute path)] [CERTIFICATE_FILE(absolute path)]',
        'upload certificate file and private key file to bigip local & install to file management'
      )
      def upload(crt_name, key_file, crt_file)
        result = []
        r = Bim::Action::SSL.upload(key_file)
        result.push Bim::Action::SSL.install(:key, crt_name, JSON.parse(r)['localFilePath'])

        r = Bim::Action::SSL.upload(crt_file)
        result.push Bim::Action::SSL.install(:crt, crt_name, JSON.parse(r)['localFilePath'])

        puts result.map { |res| JSON.parse(res) }.to_json
      end

      desc(
        'create_ssl_profile [PROFILENAME] [CHAIN]',
        'create ssl profile using already install private key and certificate file'
      )
      def create_ssl_profile(profilename, chain)
        puts Bim::Action::SSL.create_ssl_profile(profilename, chain)
      end

      desc(
        'replace [OLD_SSL_PROFILE_NAME] [NEW_SSL_PROFILE_NAME]',
        'replace ssl profile OLD_SSL_PROFILE_NAME to NEW_SSL_PROFILE_NAME'
      )
      method_option :test, type: :boolean
      def replace(old_ssl_profilename, new_ssl_profilename)
        if options[:test] && !ENV['TEST_VS']
          puts 'You have to set TEST_VS environment variable.'
          return
        end

        puts Bim::Action::SSL.replace(old_ssl_profilename, new_ssl_profilename, options[:test])
      end

      desc(
        'deploy [OLD_SSL_PROFILE_NAME] [NEW_SSL_PROFILE_NAME PRIVATE_KEYFILE] [CERTIFICATE_FILE] [CHAIN]',
        'deploy task do all need task, upload, create_ssl_profile, replace'
      )
      method_option :test, type: :boolean
      def deploy(old_ssl_profilename, new_ssl_profilename, key_file, crt_file, chain)
        if options[:test] && !ENV['TEST_VS']
          puts 'You have to set TEST_VS environment variable.'
          return
        end

        log('start deploy')
        log('start upload private key and certificate')
        upload(new_ssl_profilename, key_file, crt_file)
        log('finish upload private key and certificate')
        log('start create ssl profile')
        create_ssl_profile(new_ssl_profilename, chain)
        log('finish create ssl profile')
        log('start replace ssl profile')
        replace(old_ssl_profilename, new_ssl_profilename)
        log('finish replace ssl profile')
        log('finish deploy')
      end

      private

      def log(msg, full_length = 50)
        l = (full_length - msg.length) / 2
        puts "#{'=' * l}#{msg}#{'=' * l}"
      end
    end
  end
end
