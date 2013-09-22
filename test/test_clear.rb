require 'minitest_helper'
require 'threadedlogger'

class TestClear < ThreadedLoggerTest
    def test_clear_without_shutdown
        logger = ThreadedLogger.instance('test/foo.log', 'daily')
        ThreadedLogger.clear
        logger = ThreadedLogger.instance('test/foo.log', 'daily')
        ThreadedLogger.clear(true)
    end
end
