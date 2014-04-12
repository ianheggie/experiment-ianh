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
      # @uri = 'http://www.google.com/index.html'
      # @bad_gateway = 'http://http502.com'
      # @uri_https = 'https://encrypted.google.com'
      # @proxy = 'http://username:password@proxy:3128'
      # @redirect = 'http://jigsaw.w3.org/HTTP/300/302.html'
      # FakeWeb.allow_net_connect = allow_net_connect()
      # FakeWeb.register_uri(:head, 'http://' << LOCALHOST_IP, :body => 'PONG')
      #
      # FakeWeb.register_uri(:get, @uri, :body => 'PONG')
      # FakeWeb.register_uri(:head, @uri, :body => 'PONG')
      # FakeWeb.register_uri(:head, @uri_https, :body => 'PONG')
      # FakeWeb.register_uri(:get, @uri_https, :body => 'PONG')
      # FakeWeb.register_uri(:head, @redirect,
      #                      :body => 'A REDIRECT',
      #                      :location => @uri,
      #                      :status => %w(302 Found))
      #
      #

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
