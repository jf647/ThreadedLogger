require 'test/unit'
require 'threadedlogger'

class ThreadedLogger
    def ThreadedLogger.clear
        if ! @@instance.nil?
            @@instance.shutdown
            @@instance = nil
        end
    end
end

class TestMethods < Test::Unit::TestCase
    def setup
        ThreadedLogger.clear
    end
    def test_levels
        logger = ThreadedLogger.instance('test/example.log', 'daily')
        assert_instance_of ThreadedLogger, logger, "constructor works with 2 args"
        %w(debug info warn error fatal).each do |level|
            assert_respond_to(logger, level.to_sym, "logger responds to level #{level}")
        end
    end
    def test_level_predicates
        logger = ThreadedLogger.instance('test/example.log', 'daily', 'info')
        assert_instance_of ThreadedLogger, logger, "constructor works with 3 args"
        %w(debug info warn error fatal).each do |level|
            assert_respond_to(logger, "#{level}?".to_sym, "logger responds to predicate #{level}?")
        end
    end
    def test_setlevel
        logger = ThreadedLogger.instance('test/example.log', 'daily', 'info')
        assert_instance_of ThreadedLogger, logger, "constructor works with 3 args"
        assert_equal(false, logger.debug?, 'debug is not on when contstructed at level info')
        logger.level = 'debug'
        assert_equal(true, logger.debug?, 'debug is on after explicitly setting level')
    end
end
