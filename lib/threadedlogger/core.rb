require 'thread'
require 'logger'

class ThreadedLogger

    LOGLEVELS = {
        'debug' => Logger::DEBUG,
        'info' => Logger::INFO,
        'warn' => Logger::WARN,
        'error' => Logger::ERROR,
        'fatal' => Logger::FATAL,
    }
    
    @@instances = nil

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

    def self.instance(*args)
        if @@instances[self].nil?
            @@instances[self] = new(*args)
        else
            if ! args.empty?
                raise ArgumentError, "instance for #{self} already constructed"
            end
        end
        return @@instances[self]
    end

    def self.clear(shutdown = false)
        if shutdown and ! @@instances[self].nil?
            @@instances[self].shutdown
        end
        @@instances[self] = nil
    end

    def self.clear_all(shutdown = false)
        if shutdown and ! @@instances.nil?
            @@instances.each_value do |obj|
                if ! obj.nil?
                    obj.shutdown
                end
            end
        end
        @@instances = Hash.new
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
        @shutdown = false
        @t = Thread.new {
            runlogger
        }
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
        if ! @shutdown
            @shutdown = true
            @queue.push(nil)
            @t.join
            @t = nil
        end

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
        while ! @shutdown
            msg = @queue.pop(false)
            if ! msg.nil?
                @log.add(msg[0], msg[1])
            end
        end

        # pop anything left on the queue off
        while ! @queue.empty?
            msg = @queue.pop(true)
            if ! msg.nil?
                @log.add(msg[0], msg[1])
            end
        end
    end
    
    # create catalog of per-subclass instances
    self.clear_all

end

