# ThreadedLogger

home :: https://github.com/jf647/ThreadedLogger

## SUMMARY:

Simple ruby logging library with a dedicated logging thread.

## DESCRIPTION:

ThreadedLogger runs a dedicated logging thread around Ruby's Logger library
to ensure that multiple threads don't step on each other's toes.

## SYNOPSIS:

    require 'threadedlogger'

    log = ThreadedLogger.instance(logfname, 'daily', 'debug')
    log.info('START')
    ...
    log.debug('super important stuff')
    ...
    log.info("STOP")
    log.shutdown

or if you have multiple loggers

    require 'threadedlogger'

    class Log1 < ThreadedLogger
    end

    class Log2 < ThreadedLogger
    end

    log1 = Log1.instance(logfname1, 'daily', 'debug')
    log2 = Log2.instance(logfname2, 'daily', 'debug')
    log1.info('START')
    ...
    log1.debug('super important stuff')
    log2.info('something that only goes to the second log')
    ...
    log1.info("STOP")
    log2.shutdown
    log1.shutdown

ThreadedLogger can be subclassed if you need to have multiple logs in a
program.  Each subclass has one logger instance, accessed via the ::instance
class method.  You can only provide arguments the first time - trying to
're-construct' the object will throw an ArgumentError.

If you only need one logger, you can just use ThreadedLogger without
subclassing it.  Instances are stored keyed on class name, and the base
class is a valid key.

Under the covers, the dedicated thread uses the standard Ruby Logger
library.  Refer to [Logger](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html)
for further detail.

The arguments are: the filename, the rotation period (defaults to 'daily'),
the loglevel (defaults to 'info') and an optional formatter proc that will
be used instead of the one that comes with Logger.

When you invoke one of the logging methods, the text is enqueued.  The
background thread constantly pops messages off this queue and logs them.  To
ensure that all queued messages have been written out, call the .shutdown
instance method before your program exits.  On a clean shutdown this should
happen automatically, but if you exit in a funky way it might not capture
the last message.

The catalog of instances can be cleared using the ::clear and ::clear_all
class methods.  Each takes an optional boolean argument indicating whether
::shutdown should be called on any active loggers before clearing them.

This library also overrides Logger.LogDevice.add_log_header to prevent it
from putting a header line at the top of a logfile when it is first opened.

## CONSTRUCTION THREAD SAFETY

ThreadedLogger does not mutex construction, as the typical use case is for
the logger to be initialized for the first time outside of threaded code. 
If you call the constructor for the first time from threaded code, you will
need to protect ::instance with some kind of synchronization to avoid a race
condition.

## LICENSE:

The MIT License (MIT)

Copyright (c) 2012, 2013 James FitzGibbon <james@nadt.net>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.

## Contributing to ThreadedLogger
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the version or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
