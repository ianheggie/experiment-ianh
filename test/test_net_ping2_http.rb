#################################################################################
# test_net_ping_http.rb
#
# Test case for the Net::PingHTTP class. This should be run via the 'test' or
# 'test:http' Rake task.
#################################################################################

require 'test-unit'

require 'net/http'
require 'uri'
require 'open-uri'

class TestNetPing2HTTP < Test::Unit::TestCase

  def setup
    ENV['http_proxy'] = ENV['https_proxy'] = ENV['no_proxy'] = nil
  end

  def test_ping()
    # See https://bugs.ruby-lang.org/issues/8645
    url = 'http://144.140.108.23:1001'
    uri = URI.parse(url)

    # A port provided here overrides anything provided in constructor
    port = 1001

    timeout = 2
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

  def test2
    test_ping
  end


end
