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

class TestThreadedLogger < Minitest::Test
    def setup
        ThreadedLogger.clear
    end
    def test_constructor
        logger = ThreadedLogger.instance('test/example.log', 'daily')
        assert_instance_of ThreadedLogger, logger, "constructor works with 2 args"
    end
    def test_constructor_with_level
        logger = ThreadedLogger.instance('test/example.log', 'daily', 'info')
        assert_instance_of ThreadedLogger, logger, "constructor works with 3 args"
    end
    def test_constructor_with_level_and_formatter
        logger = ThreadedLogger.instance('test/example.log', 'daily', 'info', proc { |l| l } )
        assert_instance_of ThreadedLogger, logger, "constructor works with 4 args"
    end
    def test_constructor_noargs
        assert_raises ArgumentError, "cannot call with no args" do
            ThreadedLogger.instance
        end
    end
    def test_singleton
        loggera = ThreadedLogger.instance('test/example.log')
        loggerb = ThreadedLogger.instance
        assert_same loggera, loggerb, "two instances are the same object"
    end
    def test_construct_twice
        assert_raises ArgumentError, "cannot call instance a second time with args" do
            ThreadedLogger.instance('test/example.log')
            ThreadedLogger.instance('test/example2.log')
        end
    end
end
