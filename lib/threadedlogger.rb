require 'thread'
require 'logger'

class ThreadedLogger

    @@instance = nil

    LOGLEVELS = {
        'debug' => Logger::DEBUG,
        'info' => Logger::INFO,
        'warn' => Logger::WARN,
        'error' => Logger::ERROR,
        'fatal' => Logger::FATAL,
    }

    private_class_method :new

    # create the logging methods
    LOGLEVELS.each do |k,v|
        log_method = k.to_sym
        test_method = "#{k}?".to_sym
        define_method(log_method) { |msg=nil|
            enqueue(v, msg)
        }
        define_method(test_method) {
            @log.send(test_method)
        }
    end

    def ThreadedLogger.instance(*args)

        if @@instance.nil?
            @@instance = new(*args)
        else
            if ! args.empty?
                raise ArgumentError, "instance already constructed"
            end
        end

        return @@instance

    end

    def initialize(file, rotation = 'daily', level = 'info', formatter = nil)

        if file.nil?
            raise ArgumentError, "log file name is required"
        end

        # create a logger
        @log = Logger.new(file, rotation)

        # set the min threshold
        send(:level=, level)

        # apply a formatter if one was given
        if ! formatter.nil?
            @log.formatter = formatter
        end

        # set up a queue and spawn a thread to do the logging
        @queue = Queue.new
        @shutdown = nil
        @t = Thread.new { runlogger }
      
    end
    
    def level=(level)
        if LOGLEVELS.has_key?(level)
            @log.level = LOGLEVELS[level]
        else
            raise ArgumentError, "invalid log level #{level}"
        end
    end
    
    def shutdown

        # stops new messages from being enqueued and tells thread
        # to drain what's in the queue
        @shutdown = true
        @t.join

    end

    def enqueue(severity, msg=nil)

        # don't enqueue if we're in shutdown
        if( @shutdown )
            return
        end

        # put the message on the queue
        @queue.push( [severity, msg] )

    end

    private

    def runlogger

        # do blocking pops off the queue until the shutdown flag is set
        while @shutdown.nil?
            msg = @queue.pop(false)
            @log.add(msg[0], msg[1])
        end

        # pop anything left on the queue off
        while ! @queue.empty?
            msg = @queue.pop(true)
            @log.add(msg[0], msg[1])
        end

    end

end

# supress the "Logfile created at" header line that logger.rb provides
class Logger

    private

    class LogDevice

        private

        def add_log_header(file)
        end

    end

end
