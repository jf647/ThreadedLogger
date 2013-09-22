$:.push File.expand_path("../lib", __FILE__)
require 'threadedlogger'

Gem::Specification.new do |s|
    s.name          = 'threadedlogger'
    s.version       = ThreadedLogger::VERSION
    s.date          = '2013-03-23'
    s.summary       = 'Simple logging library with a dedicated logging thread'
    s.homepage      = 'https://github.com/jf647/ThreadedLogger'
    s.authors       = ['James FitzGibbon']
    s.email         = ['james@nadt.net']
    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f)
end
