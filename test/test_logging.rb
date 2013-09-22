require 'minitest_helper'
require 'minitest/autorun'
require 'threadedlogger'
require 'fakefs'

class ThreadedLogger
    def ThreadedLogger.clear
        if ! @@instance.nil?
            @@instance.shutdown
            @@instance = nil
        end
    end
end

class TestLogging < Minitest::Test
    def setup
        ThreadedLogger.clear
    end
    def test_logging
        logger = ThreadedLogger.instance('foo.log', 'daily')
        logger.info 'foo'
        File.exists?('foo.log')
        logger.shutdown
    end
end
