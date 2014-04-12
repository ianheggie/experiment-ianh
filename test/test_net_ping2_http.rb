#################################################################################
# test_net_ping_http.rb
#
# Test case for the Net::PingHTTP class. This should be run via the 'test' or
# 'test:http' Rake task.
#################################################################################

require 'test-unit'

LOCALHOST = 'localhost'
BOGUS_HOST = 'foo.bar.baz'

LOCALHOST_IP = '127.0.0.1'
DEFAULT_BLACKHOLE_IP = '144.140.108.23' # telstra.com - aussie ISP that drops packets
DEFAULT_BLACKHOLE_PORT = 1001

require 'net/ping2/http'

class TestNetPing2HTTP < Test::Unit::TestCase
  #extend TestHelper

  def setup
    #extend TestHelper
    ENV['http_proxy'] = ENV['https_proxy'] = ENV['no_proxy'] = nil

    @ping = Net::Ping2::HTTP.new()
  end


  def test_a
  @ping.ping()
  end

  def test_b
    @ping.ping()
  end

  def test_c
    @ping.ping()
  end

end
