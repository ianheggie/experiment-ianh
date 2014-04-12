require 'net/ping2/base'
require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'

# Force non-blocking Socket.getaddrinfo on Unix systems. Do not use on
# Windows because it (ironically) causes blocking problems.
unless File::ALT_SEPARATOR or RUBY_VERSION >= "1.9.3"
  require 'resolv-replace'
end

# The Net module serves as a namespace only.
module Net
  module Ping2

    # The Net::Ping2::HTTP class encapsulates methods for HTTP pings.
    class HTTP < Base

      # The port to ping. Defaults to port 80.
      #
      attr_accessor :port

      # By default an http ping will follow a redirect and give you the result
      # of the final URI.  If this value is set to false, then it will not
      # follow a redirect and will return false immediately on a redirect.
      #

      # Creates and returns a new Net::Ping2::HTTP object.
      # The default port is 80,
      # The default timeout is 10 seconds.
      #
      def initialize(options = {})
        @ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
        @port = 80
        @port = URI.parse(options[:host]).port if options[:host]
        @user_agent = 'net-ping2'
        super(options)
      end

      # Looks for an HTTP response from the URI passed to the constructor.
      # If the result is a kind of Net::HTTPSuccess then the ping was
      # successful and true is returned.  Otherwise, false is returned
      # and the Net::Ping2::HTTP#exception method should contain a string
      # indicating what went wrong.
      #
      # If the HTTP#follow_redirect accessor is set to true (which it is
      # by default) and a redirect occurs during the ping, then the
      # HTTP#warning attribute is set to the redirect message, but the
      # return result is still true. If it's set to false then a redirect
      # response is considered a failed ping.
      #
      # If no file or path is specified in the URI, then '/' is assumed.
      # If no scheme is present in the URI, then 'http' is assumed.
      #
      def ping(host = nil, options = {})

        super(host, options)

        # See https://bugs.ruby-lang.org/issues/8645
        url = host || @host
        if url !~ %r{^https?://}
          url = "url://#{url}"
        end
        uri = URI.parse(url)

        # A port provided here overrides anything provided in constructor
        port = options[:port]
        port ||= uri.port if host
        port ||= @port

        timeout = options[:timeout] || @timeout

        do_ping(uri, port, timeout)

      end

      protected

      def clear_results
        super()
        @proxied = @code = nil
      end

      private

      def do_ping(uri, port, timeout)
        http_response = nil
        proxy = uri.find_proxy || URI.parse("")
        uri_path = uri.path.empty? ? '/' : uri.path
        headers = {}
        headers["User-Agent"] = 'net-ping2'
        begin
          http = Net::HTTP::Proxy(proxy.host, proxy.port, proxy.user, proxy.password).new(uri.host, port)
          http.read_timeout = timeout
          http.open_timeout = timeout
          @proxied = http.proxy?
          request = Net::HTTP::Head.new(uri_path)
          http_response = Timeout.timeout(timeout) do
            http.start { |h| h.request(request) }
          end
        rescue Exception => err
          @exception = err.message
        ensure
          http.open_timeout = 999  # DEBUG
        end
      end
    end
  end
end
