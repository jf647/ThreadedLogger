require 'minitest_helper'

# Tests passing an alternate logger
class TestLogging < ThreadedLoggerTest
  def test_logging
    logger = ThreadedLogger.instance('test/foo.log', 'daily')
    logger.info 'foo'
    File.exist?('test/foo.log')
    logger.shutdown
  end
end
