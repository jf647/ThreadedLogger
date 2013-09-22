require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
]
SimpleCov.start do
    add_filter '/vendor/'
    add_filter '/test/'
end

require 'minitest/autorun'
require 'minitest/debugger' if ENV['DEBUG']
require 'threadedlogger'

class ThreadedLoggerTest < Minitest::Test
    def teardown
        ThreadedLogger.clear_all(true)
    end
end
