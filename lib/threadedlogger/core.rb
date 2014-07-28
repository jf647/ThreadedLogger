require 'thread'
require 'logger'

# a Logger with a dedicated logging thread
class ThreadedLogger
  LOGLEVELS = {
    'debug' => Logger::DEBUG,
    'info' => Logger::INFO,
    'warn' => Logger::WARN,
    'error' => Logger::ERROR,
    'fatal' => Logger::FATAL
  }

  # create catalog of per-subclass instances
  @@instances = nil

  private_class_method :new

  # create the logging methods
  LOGLEVELS.each do |k, v|
    log_method = k.to_sym
    test_method = "#{k}?".to_sym
    define_method(log_method) { |msg = nil| enqueue(v, msg) }
    define_method(test_method) { @log.send(test_method) }
  end

  def self.initialized?
    ! @@instances[self].nil?
  end

  def self.instance(*args)
    if @@instances[self].nil?
      @@instances[self] = new(*args)
    else
      unless args.empty?
        fail ArgumentError, "instance for #{self} already constructed"
      end
    end
    @@instances[self]
  end

  def self.clear(shutdown = false)
    @@instances[self].shutdown if shutdown && ! @@instances[self].nil?
    @@instances[self] = nil
  end

  def self.clear_all(shutdown = false)
    if shutdown && ! @@instances.nil?
      @@instances.each_value do |obj|
        obj.shutdown unless obj.nil?
      end
    end
    @@instances = {}
  end

  def initialize(file, rotation = 'daily', level = 'info', formatter = nil)
    fail ArgumentError, 'log file name is required' if file.nil?

    # create a logger
    @log = Logger.new(file, rotation)

    # set the min threshold
    send(:level=, level)

    # apply a formatter if one was given
    @log.formatter = formatter unless formatter.nil?

    # set up a queue and spawn a thread to do the logging
    @queue = Queue.new
    @shutdown = false
    @t = Thread.new do
      runlogger
    end
  end

  def level=(level)
    if LOGLEVELS.key?(level)
      @log.level = LOGLEVELS[level]
    else
      fail ArgumentError, "invalid log level #{level}"
    end
  end

  def shutdown
    # stops new messages from being enqueued and tells thread
    # to drain what's in the queue
    return unless @shutdown
    @shutdown = true
    @queue.push(nil)
    @t.join
    @t = nil
  end

  def enqueue(severity, msg = nil)
    # don't enqueue if we're in shutdown
    return if @shutdown

    # put the message on the queue
    @queue.push([severity, msg])
  end

  private

  def runlogger
    # do blocking pops off the queue until the shutdown flag is set
    until @shutdown
      msg = @queue.pop(false)
      @log.add(msg[0], msg[1]) unless msg.nil?
    end

    # pop anything left on the queue off
    until @queue.empty?
      msg = @queue.pop(true)
      @log.add(msg[0], msg[1]) unless msg.nil?
    end
  end

  clear_all
end
