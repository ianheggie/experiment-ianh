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
    port = 1001
    host = '144.140.108.23'
    #uri = URI.parse(url)

    # A port provided here overrides anything provided in constructor

    timeout = 1
    #headers = {}
    #headers["User-Agent"] = 'net-ping2'
    begin
      http = Net::HTTP.new(host, port)
      #http.read_timeout = timeout
      http.open_timeout = timeout
      request = Net::HTTP::Head.new('/')
      http_response = Timeout.timeout(timeout) do
        http.start { |h| h.request(request) }
      end
      #http_response =  http.start { |h| h.request(request) }

    rescue TimeoutError => err
       puts "Rescued from timeout (as expected)"
    end
  end

  def test2
    test_ping
  end


end
