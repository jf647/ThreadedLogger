require 'minitest_helper'

# Tests clearing ThreadedLogger singletons
class TestClear < ThreadedLoggerTest
  def test_clear_without_shutdown
    ThreadedLogger.instance('test/foo.log', 'daily')
    ThreadedLogger.clear
    ThreadedLogger.instance('test/foo.log', 'daily')
    ThreadedLogger.clear(true)
  end
end
