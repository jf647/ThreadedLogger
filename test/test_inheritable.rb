require 'minitest_helper'
require 'threadedlogger'

class OurLog1 < ThreadedLogger
end

class OurLog2 < ThreadedLogger
end

class TestInheritable < ThreadedLoggerTest
    def test_construct_subclass
        logger = OurLog1.instance('test/foo.log', 'daily')
        assert_instance_of(OurLog1, logger)
        logger.info 'foo'
        File.exists?('test/foo.log')
        logger.shutdown
    end
    def test_construct_two_subclasses
        logger1 = OurLog1.instance('test/foo.log', 'daily')
        logger2 = OurLog2.instance('test/bar.log', 'daily')
        assert_instance_of(OurLog1, logger1)
        assert_instance_of(OurLog2, logger2)
        logger1.info 'foo'
        logger2.info 'bar'
        File.exists?('test/foo.log')
        File.exists?('test/bar.log')
        logger1.shutdown
        logger2.shutdown
    end
    def test_reconstruct_subclass
        logger1 = OurLog1.instance('test/foo.log', 'daily')
        logger2 = OurLog2.instance('test/bar.log', 'daily')
        assert_instance_of(OurLog1, logger1)
        assert_instance_of(OurLog2, logger2)
        assert_raises(ArgumentError) {
            OurLog1.instance('test/foo.log', 'daily')
        }
        assert_raises(ArgumentError) {
            OurLog2.instance('test/bar.log', 'daily')
        }
    end
    def test_clear
        logger1 = OurLog1.instance('test/foo.log', 'daily')
        logger2 = OurLog2.instance('test/bar.log', 'daily')
        assert_instance_of(OurLog1, logger1)
        assert_instance_of(OurLog2, logger2)
        assert_raises(ArgumentError) {
            OurLog1.instance('test/foo.log', 'daily')
        }
        OurLog1.clear
        logger2b = OurLog2.instance
        assert_instance_of(OurLog2, logger2b)
        assert_equal logger2b, logger2
        logger1 = OurLog1.instance('test/foo.log', 'daily')
        assert_instance_of(OurLog1, logger1)
    end
    def test_clear_all
        logger1 = OurLog1.instance('test/foo.log', 'daily')
        assert_instance_of(OurLog1, logger1)
        assert_raises(ArgumentError) {
            OurLog1.instance('test/foo.log', 'daily')
        }
        ThreadedLogger.clear_all
        logger1 = OurLog1.instance('test/foo.log', 'daily')
        assert_instance_of(OurLog1, logger1)
    end
end
