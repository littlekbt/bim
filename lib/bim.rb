require 'base64'
require 'json'
require 'bim/version'

module Bim
  BIGIP_HOST  = ENV['BIGIP_HOST']
  BASE_URL    = "https://#{BIGIP_HOST}/".freeze
  TEST_VS     = ENV['TEST_VS'].to_s
  USER_ID     = ENV['BIGIP_USER_ID']
  USER_PASSWD = ENV['BIGIP_PASSWD']
  AUTH        = ::Base64.encode64("#{USER_ID}:#{USER_PASSWD}").chomp

  class UnsetEnvironmentError < StandardError; end
  class UnsetHostEnvironmentError     < UnsetEnvironmentError; end
  class UnsetUserIDEnvironmentError   < UnsetEnvironmentError; end
  class UnsetPasswordEnvironmentError < UnsetEnvironmentError; end
  class UnauthorizedError < StandardError; end
end

require 'bim/cli'
