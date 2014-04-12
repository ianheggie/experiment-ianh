#################################################################################
# test_net_ping_http.rb
#
# Test case for the Net::PingHTTP class. This should be run via the 'test' or
# 'test:http' Rake task.
#################################################################################
require File.expand_path('../test_helper.rb', __FILE__)
require 'net/ping2/http'

class TestNetPing2HTTP < Test::Unit::TestCase
  #extend TestHelper

  def setup
    extend TestHelper
    ENV['http_proxy'] = ENV['https_proxy'] = ENV['no_proxy'] = nil

    @ping = Net::Ping2::HTTP.new()
  end


  def test_pinging_returns_false_and_sets_attributes_accordingly
  @ping.timeout = 2
  @ping.port = DEFAULT_BLACKHOLE_PORT
  @ping.ping(DEFAULT_BLACKHOLE_IP)
  end

  def test_pinging_returns_false_and_sets_attributes_accordingly_2nd
  @ping.timeout = 2
  @ping.port = DEFAULT_BLACKHOLE_PORT
  @ping.ping(DEFAULT_BLACKHOLE_IP)
  end

  def test_pinging_returns_false_and_sets_attributes_accordingly_3rd
  @ping.timeout = 2
  @ping.port = DEFAULT_BLACKHOLE_PORT
  @ping.ping(DEFAULT_BLACKHOLE_IP)
  end

end
