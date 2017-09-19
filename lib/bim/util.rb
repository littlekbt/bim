require 'base64'
require 'net/http'
require 'openssl'

module Bim
  # Util module defined common methods
  module Util
    VS_PATH = '/mgmt/tm/ltm/virtual'.freeze

    private

    def get_body(uri)
      raise UnsetHostEnvironmentError if BIGIP_HOST.nil?
      raise UnsetUserIDEnvironmentError if USER_ID.nil?
      raise UnsetPasswordEnvironmentError if USER_PASSWD.nil?

      res = http(uri).request(request(uri, Bim::AUTH, 'application/json'))

      raise UnauthorizedError if res.code == '401'

      res.body
    end

    def http(uri)
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def request(uri, auth, content_type, method = 'GET', body = nil)
      req = case method
            when 'GET'
              Net::HTTP::Get.new(uri)
            when 'POST'
              Net::HTTP::Post.new(uri)
            when 'PATCH'
              Net::HTTP::Patch.new(uri)
            end

      req['Content-Type'] = content_type
      req['Authorization'] = "Basic #{auth}"
      req.body = body

      block_given? ? yield(req) : req
    end

    def yes_or_no?(msg)
      print msg
      STDIN.gets.chomp.match?(/^[yY]/)
    end

    def vs_list
      uri = URI.join(BASE_URL, VS_PATH)
      get_body(uri)
    end

    def profiles(link)
      uri = URI.parse(link.sub('localhost', BIGIP_HOST))
      get_body(uri)
    end
  end
end
