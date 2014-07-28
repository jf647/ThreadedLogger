require 'minitest_helper'

# dummy class to create two loggers
class OurLog1 < ThreadedLogger
end

# dummy class to create two loggers
class OurLog2 < ThreadedLogger
end

# Tests the initialized flag
class TestInitializedFlag < ThreadedLoggerTest
  def test_initialized_base
    assert_equal false, ThreadedLogger.initialized?, 'instance is not initialized'
    logger = ThreadedLogger.instance('test/foo.log', 'daily', 'info')
    assert_instance_of ThreadedLogger, logger, 'construct ThreadedLogger'
    assert_equal true, ThreadedLogger.initialized?, 'instance is initialized'
  end

  def test_initialized_subclass
    assert_equal false, ThreadedLogger.initialized?, 'ThreadedLogger is not initialized'
    assert_equal false, OurLog1.initialized?, 'OurLog1 is not initialized'
    assert_equal false, OurLog2.initialized?, 'OurLog2 is not initialized'
    logger = ThreadedLogger.instance('test/foo.log', 'daily', 'info')
    assert_instance_of ThreadedLogger, logger, 'construct ThreadedLogger'
    assert_equal true, ThreadedLogger.initialized?, 'ThreadedLogger is initialized'
    assert_equal false, OurLog1.initialized?, 'OurLog1 is not initialized'
    assert_equal false, OurLog2.initialized?, 'OurLog2 is not initialized'
    ourlog1 = OurLog1.instance('test/bar.log', 'daily', 'info')
    assert_instance_of OurLog1, ourlog1, 'construct OurLog1'
    assert_equal true, ThreadedLogger.initialized?, 'ThreadedLogger is initialized'
    assert_equal true, OurLog1.initialized?, 'OurLog1 is initialized'
    assert_equal false, OurLog2.initialized?, 'OurLog2 is not initialized'
    ourlog2 = OurLog2.instance('test/baz.log', 'daily', 'info')
    assert_instance_of OurLog2, ourlog2, 'construct OurLog2'
    assert_equal true, ThreadedLogger.initialized?, 'ThreadedLogger is initialized'
    assert_equal true, OurLog1.initialized?, 'OurLog1 is initialized'
    assert_equal true, OurLog2.initialized?, 'OurLog2 is initialized'
  end

  def test_initialized_clear
    assert_equal false, ThreadedLogger.initialized?, 'instance is not initialized'
    logger = ThreadedLogger.instance('test/foo.log', 'daily', 'info')
    assert_instance_of ThreadedLogger, logger, 'construct ThreadedLogger'
    assert_equal true, ThreadedLogger.initialized?, 'instance is initialized'
    ThreadedLogger.clear
    assert_equal false, ThreadedLogger.initialized?, 'instance is not initialized after clear'
  end

  def test_initialized_clear_all
    assert_equal false, ThreadedLogger.initialized?, 'ThreadedLogger is not initialized'
    assert_equal false, OurLog1.initialized?, 'OurLog1 is not initialized'
    assert_equal false, OurLog2.initialized?, 'OurLog2 is not initialized'
    logger = ThreadedLogger.instance('test/foo.log', 'daily', 'info')
    assert_instance_of ThreadedLogger, logger, 'construct ThreadedLogger'
    ourlog1 = OurLog1.instance('test/bar.log', 'daily', 'info')
    assert_instance_of OurLog1, ourlog1, 'construct OurLog1'
    ourlog2 = OurLog2.instance('test/baz.log', 'daily', 'info')
    assert_instance_of OurLog2, ourlog2, 'construct OurLog2'
    assert_equal true, ThreadedLogger.initialized?, 'ThreadedLogger is initialized'
    assert_equal true, OurLog1.initialized?, 'OurLog1 is initialized'
    assert_equal true, OurLog2.initialized?, 'OurLog2 is initialized'
    ThreadedLogger.clear_all
    assert_equal false, ThreadedLogger.initialized?,
                 'ThreadedLogger is not initialized after clear_all'
    assert_equal false, OurLog1.initialized?, 'OurLog1 is not initialized after clear_all'
    assert_equal false, OurLog2.initialized?, 'OurLog2 is not initialized after clear_all'
  end
end
