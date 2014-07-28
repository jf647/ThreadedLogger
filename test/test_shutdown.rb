require 'minitest_helper'

# Tests shutting down the logger
class TestShutdown < ThreadedLoggerTest
  def test_enqueue_after_shutdown
    logger = ThreadedLogger.instance('test/foo.log', 'daily')
    logger.shutdown
    logger.info('foo')
  end
end
