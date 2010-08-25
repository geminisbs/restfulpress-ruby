require 'uri'
require 'yajl'
require 'rest_client'

require 'restful_press/connection'
require 'restful_press/endpoint'
require 'restful_press/hash_utils'
require 'restful_press/client'

module RestfulPress
  REALM = "http://quick-pdf.geminisbs.net"
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  class RestfulPressError < StandardError; end
  class Unauthorized < RestfulPressError; end
  class NotFound < RestfulPressError; end
  class APIKeyExpired < RestfulPressError; end
  class MethodNotAllowed < RestfulPressError; end
  class ServerError < RestfulPressError; end
  class Unavailable < RestfulPressError; end
  class DecodeError < RestfulPressError; end
  class NoConnectionEstablished < RestfulPressError; end
end
