ThreadedLogger
==============

Overview
--------

Simple ruby logging library with a dedicated logging thread.

Synopsis
--------

```ruby
require 'threadedlogger'

log = ThreadedLogger.instance(logfname, 'daily', 'debug')
log.info('START')
...
log.debug('super important stuff')
...
log.info("STOP")
log.shutdown

log2 = ThreadedLogger.instance(logfname, 'daily', 'debug', proc { |l| "prefix: #{l}" })
```

ThreadedLogger has one and only one instance, accessed via the .instance class method.  You can only
provide arguments the first time - trying to 're-construct' the object will throw an ArgumentError.

Under the covers, the dedicated thread uses the standard Ruby Logger library. Refer to
[Logger](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html) for further detail.

The arguments are: the filename, the rotation period (defaults to 'daily'), the loglevel
(defaults to 'info') and an optional formatter proc that will be used instead of the one that comes
with Logger.

When you invoke one of the logging methods, the text is enqueued.  The background thread constantly
pops messages off this queue and logs them.  To ensure that all queued messages have been written out,
call the .shutdown instance method before your program exits.  On a clean shutdown this should happen
automatically, but if you exit in a funky way it might not capture the last message.

This library also overrides Logger.LogDevice.add_log_header to prevent it from putting a header line
at the top of a logfile when it is first opened.

Contributing to ThreadedLogger
------------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the version or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
