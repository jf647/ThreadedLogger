require 'minitest_helper'

# Tests ThreadedLogger
class TestThreadedLogger < ThreadedLoggerTest
  def test_constructor
    logger = ThreadedLogger.instance('test/foo.log', 'daily')
    assert_instance_of ThreadedLogger, logger, 'constructor works with 2 args'
  end

  def test_constructor_with_level
    logger = ThreadedLogger.instance('test/foo.log', 'daily', 'info')
    assert_instance_of ThreadedLogger, logger, 'constructor works with 3 args'
  end

  def test_constructor_with_level_and_formatter
    logger = ThreadedLogger.instance('test/foo.log', 'daily', 'info', proc { |l| l })
    assert_instance_of ThreadedLogger, logger, 'constructor works with 4 args'
  end

  def test_constructor_noargs
    assert_raises ArgumentError, 'cannot call with no args' do
      ThreadedLogger.instance
    end
  end

  def test_singleton
    loggera = ThreadedLogger.instance('test/foo.log')
    loggerb = ThreadedLogger.instance
    assert_same loggera, loggerb, 'two instances are the same object'
  end

  def test_construct_twice
    assert_raises ArgumentError, 'cannot call instance a second time with args' do
      ThreadedLogger.instance('test/foo.log')
      ThreadedLogger.instance('test/bar.log')
    end
  end
end
