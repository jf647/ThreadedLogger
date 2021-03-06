require 'minitest_helper'
require 'threadedlogger'

class TestLogging < ThreadedLoggerTest
    def test_logging
        logger = ThreadedLogger.instance('test/foo.log', 'daily')
        logger.info 'foo'
        File.exists?('test/foo.log')
        logger.shutdown
    end
end
