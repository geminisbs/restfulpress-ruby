module RestfulPress

  class Client

    @@connection = nil
    @@debug = false

    class << self

      def set_credentials(api_key)
        @@connection = Connection.new(api_key)
        @@connection.debug = @@debug
        true
      end

      def debug=(debug_flag)
        @@debug = debug_flag
        @@connection.debug = @@debug if @@connection
      end

      def debug
        @@debug
      end
      
      def add_job(*args)
        options = extract_options!(args)
        params = Hash.new
        params[:job] = options
        
        response = post(Endpoint.jobs, params)
        HashUtils.recursively_symbolize_keys(response)
      end
      
      def get_job(id)
        response = get(Endpoint.job(id))
        HashUtils.recursively_symbolize_keys(response)
      end
      
      def get_jobs
        response = get(Endpoint.jobs)
        HashUtils.recursively_symbolize_keys(response)
      end
      
      def delete_job(id)
        response = delete(Endpoint.job(id))
        if response.nil?
          return true
        else
          HashUtils.recursively_symbolize_keys(response)
        end
      end
      
      def job_url(id)
        Endpoint.download_job(id)
      end
      
      def job_download(id)
        response = get(Endpoint.download_job(id))
        HashUtils.recursively_symbolize_keys(response)
      end
      
      def job_complete?(id)
        get_job(id)[:complete]
      end

      def get(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.get endpoint, data
      end

      def delete(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.delete endpoint, data
      end

      def post(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.post endpoint, data
      end

      def put(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.put endpoint, data
      end

    private

      def extract_options!(args)
        if args.last.is_a?(Hash)
          return args.pop
        else
          return {}
        end
      end

    end

  end

end
