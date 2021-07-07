require 'rack'

module ActiveJob
  class Rack
    class << self
      # Regex to test base64 encoded strings (https://rgxdb.com/r/1NUN74O6)
      BASE64_REGEX = %r{^(?:[a-zA-Z0-9+/]{4})*(?:|(?:[a-zA-Z0-9+/]{3}=)|(?:[a-zA-Z0-9+/]{2}==)|(?:[a-zA-Z0-9+/]{1}===))$}.freeze

      def call(env)
        request = ActionDispatch::Request.new(env)
        if request.headers['X-Cloudtasks-Taskretrycount'].to_i != 0
          Rails.logger.error request.env
          raise "[Job] BUG/TIMEOUT - Should not happen #{parse_params(request)}"
        end

        ActiveJob::Base.execute parse_params(request)

        [200, {}, ['ok']]
      end

      private

      def klass(job)
        Kernel.const_get(job.camelize)
      end

      def parse_params(request)
        params = if request.body.string.match?(BASE64_REGEX)
                   Base64.strict_decode64(request.body.string).force_encoding('UTF-8').encode
                 else
                   request.body.string
                 end
        parsed_params = JSON.parse(params)

        Rails.logger.warn "[Job] #{parsed_params}"
        parsed_params
      end
    end
  end
end
