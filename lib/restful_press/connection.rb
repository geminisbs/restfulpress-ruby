module RestfulPress

  class Connection

    attr_accessor :debug
    attr_reader :api_key, :default_options

    def initialize(api_key)
      @api_key = api_key
      @default_options = { :api_key => @api_key }
      @debug = false
    end

    def get(endpoint, data=nil)
      request :get, endpoint, data
    end

    def delete(endpoint, data=nil)
      request :delete, endpoint, data
    end

    def post(endpoint, data=nil)
      request :post, endpoint, data
    end

    def put(endpoint, data=nil)
      request :put, endpoint, data
    end

  private

    def request(method, endpoint, data=nil)
      headers = { 'User-Agent' => "RestfulPress Ruby Client v#{VERSION}",
                  'Content-Type' => "application/json"
                }
      
      if data.nil?
        data = @default_options
      else
        data.merge!(@default_options)
      end

      if [:get, :delete].include?(method)
        endpoint = endpoint + '?' + build_query(data)
      end

      if debug
        puts "request: #{method.to_s.upcase} #{endpoint}"
        puts "headers:"
        headers.each do |key, value|
          puts "#{key}=#{value}"
        end
        if [:post, :put].include?(method)
          puts "data:"
          puts Yajl::Encoder.encode data
        end
      end

      case method
        when :get, :delete
          response = send_request(method, endpoint, headers)
        when :post, :put
          data = Yajl::Encoder.encode data
          response = send_request(method, endpoint, headers, data)
      end

      if debug
        puts "\nresponse: #{response.code}"
        puts "headers:"
        response.header.each do |key, value|
          puts "#{key}=#{value}"
        end
        puts "body:"
        puts response.body
      end

      if response.body.empty?
        content = nil
      else
        begin
          content = Yajl::Parser.new.parse(response.body)
        rescue Yajl::ParseError
          raise DecodeError, "content: <#{response.body}>"
        end
      end

      content
    end

    def build_query(data)
      data = data.to_a if data.is_a?(Hash)
      data.map do |key, value|
        [key.to_s, URI.escape(value.to_s)].join('=')
      end.join('&')
    end

    def send_request(method, endpoint, headers, data=nil)
      begin
        case method
          when :get
            response = RestClient.get endpoint, headers
          when :delete
            response = RestClient.delete endpoint, headers
          when :post
            response = RestClient.post endpoint, data, headers
          when :put
            response = RestClient.put endpoint, data, headers
        end
      rescue => e
        raise_errors(e.response)
      end

      response
    end

    def raise_errors(response)
      case response.code
        when 401
          raise Unauthorized
        when 403
          raise APIKeyExpired
        when 404
          raise NotFound
        when 405
          raise MethodNotAllowed
        when 422
          raise RestfulPressError, "#{response.description}\n#{response.body}"
        when 500
          raise ServerError, "RestfulPress had an internal error. #{response.description}"
        when 502..503
          raise Unavailable, response.description
        else
          raise RestfulPressError, response.description
      end
    end

  end

end
