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

end

class Test::Unit::TestCase
  extend TestHelper
end
