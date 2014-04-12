#!/usr/bin/env ruby

require 'test-unit'

LOCALHOST = 'localhost'
BOGUS_HOST = 'foo.bar.baz'

LOCALHOST_IP = '127.0.0.1'
DEFAULT_BLACKHOLE_IP = '144.140.108.23' # telstra.com - aussie ISP that drops packets
DEFAULT_BLACKHOLE_PORT = 1001

if defined? SimpleCov
  SimpleCov.start :rails do
    filters.clear # This will remove the :root_filter that comes via simplecov's defaults
    add_filter do |src|
      !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ %r{lib/net/ping2}
    end
  end
end

module TestHelper

  def local_tcp_port
    (ENV['LOCAL_TCP_PORT'] || 22).to_i
  end

  # ---------------------------
  # Helpers to add tests


  def check_bad_hosts_behaviour(bad_host_name_list, should_be_set = [], should_be_nil = [])
    klass = self
    bad_host_name_list.each do |name, host|
      define_method "test_pinging_#{name}_returns_false_and_sets_attributes_accordingly" do
        @ping.timeout = 2
        @ping.port = klass.blackhole_port if @ping.respond_to? :port=
        started = Time.now
        @result = @ping.ping?(host)
        @duration = Time.now - started
        assert_false(@result, "ping?(#{host}) should be false, exception = #{@ping.exception}, response = #{@ping.response}")
        assert_false(@ping.success?)
        ['exception', 'success', should_be_set].flatten.each do |method|
          assert_not_nil(@ping.send(method), "#{method} should be set on failure") if method
        end
        ['duration', should_be_nil].flatten.each do |method|
          assert_nil(@ping.send(method), "#{method} should be nil on failure") if method
        end
        assert_true(@duration < 3.9, "pinging #{name} should take < 3.9 seconds, actually took #{@duration}")
      end
    end
  end




# ------------------------------------------
# common definitions


  def bad_hostname
    'no.such.domain.exists'
  end

  def blackhole_ip
    if ENV['BLACKHOLE_IP'].to_s =~ /(\S+)/
      $1
    else
      DEFAULT_BLACKHOLE_IP
    end
  end

  def blackhole_port
    if ENV['BLACKHOLE_PORT'].to_s =~ /(\d+)/
      $1.to_i
    else
      DEFAULT_BLACKHOLE_PORT
    end
  end

  def allow_net_connect
    res = '127.0.0.1'
    bad_hosts.each do |name, host, port|
      res << '|' << host if host != self.bad_hostname
    end
    %r[^https?://(#{res.gsub('.', '\.')})]
  end

  def bad_hosts
    port = self.blackhole_port
    #res = [['bogus_hostname', self.bad_hostname, port]]
    res = [ ['blackhole_ip', self.blackhole_ip, port] ]
    res
  end

end

class Test::Unit::TestCase
  extend TestHelper
end
