module RestfulPress

  class Endpoint

    class << self
      
      def job(id)
        endpoint_url ["jobs", "#{id}.json"].join('/')
      end
      
      def jobs
        endpoint_url "jobs.json"
      end
      
      def download_job(id)
        endpoint_url ["jobs", id, "download"].join('/')
      end

      def endpoint_url(path)
        [REALM, path].join('/')
      end

    end

  end

end
