#################################################################################
# test_net_ping_http.rb
#
# Test case for the Net::PingHTTP class. This should be run via the 'test' or
# 'test:http' Rake task.
#################################################################################
require File.expand_path('../test_helper.rb', __FILE__)
require 'fakeweb'
require 'net/ping2/http'

class TestNetPing2HTTP < Test::Unit::TestCase
  #extend TestHelper

  if Net::Ping2::HTTP.available?

    def setup
      extend TestHelper
      ENV['http_proxy'] = ENV['https_proxy'] = ENV['no_proxy'] = nil

      @ping = Net::Ping2::HTTP.new(:timeout => 30, :port => 80)

      @ping = Net::Ping2::HTTP.new()
      @ping_with_host = Net::Ping2::HTTP.new(:host => LOCALHOST_IP)

    end

    def teardown
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect = true
    end

    check_bad_hosts_behaviour(self.bad_hosts)


  else
    def test_new_raises_exception
      assert_raise(NotImplementedError) { Net::Ping2::HTTP.new }
    end

    def tests_are_disabled
      omit('tests are disabled: ' + Net::Ping2::HTTP.not_available_message)
    end

  end


end
