# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'threadedlogger'
  s.version = '1.3.0.20131002111917'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['James FitzGibbon']
  s.date = '2013-10-02'
  s.description = "ThreadedLogger runs a dedicated logging thread around Ruby's Logger library\nto ensure that multiple threads don't step on each other's toes."
  s.email = ['james@nadt.net']
  s.extra_rdoc_files = ['History.txt', 'Manifest.txt', 'README.txt', 'LICENSE.txt']
  s.files = ['History.txt', 'Manifest.txt', 'README.txt', 'LICENSE.txt', 'Rakefile', 'lib/threadedlogger.rb', 'lib/threadedlogger/core.rb', 'lib/threadedlogger/version.rb', 'lib/threadedlogger/logger.rb', 'test/minitest_helper.rb', 'test/test_logging.rb', 'test/test_methods.rb', 'test/test_threadedlogger.rb', 'test/test_shutdown.rb', 'test/test_clear.rb', 'test/test_initialized_flag.rb', 'threadedlogger.gemspec', 'test/test_inheritable.rb', '.gemtest']
  s.homepage = 'https://github.com/jf647/ThreadedLogger'
  s.licenses = ['MIT']
  s.rdoc_options = ['--main', 'README.txt']
  s.require_paths = ['lib']
  s.rubyforge_project = 'threadedlogger'
  s.rubygems_version = '1.8.23'
  s.summary = "ThreadedLogger runs a dedicated logging thread around Ruby's Logger library to ensure that multiple threads don't step on each other's toes."
  s.test_files = ['test/test_methods.rb', 'test/test_initialized_flag.rb', 'test/test_inheritable.rb', 'test/test_clear.rb', 'test/test_shutdown.rb', 'test/test_logging.rb', 'test/test_threadedlogger.rb']

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency('rdoc', ['~> 4.0'])
      s.add_development_dependency('rake', ['~> 10.1.0'])
      s.add_development_dependency('hoe', ['~> 3.7.1'])
      s.add_development_dependency('hoe-gemspec', ['~> 1.0.0'])
      s.add_development_dependency('hoe-bundler', ['~> 1.2.0'])
      s.add_development_dependency('simplecov', ['~> 0.7.1'])
      s.add_development_dependency('simplecov-console', ['~> 0.1.1'])
      s.add_development_dependency('minitest', ['~> 5.0.8'])
      s.add_development_dependency('minitest-debugger', ['~> 1.0.2'])
    else
      s.add_dependency('rdoc', ['~> 4.0'])
      s.add_dependency('rake', ['~> 10.1.0'])
      s.add_dependency('hoe', ['~> 3.7.1'])
      s.add_dependency('hoe-gemspec', ['~> 1.0.0'])
      s.add_dependency('hoe-bundler', ['~> 1.2.0'])
      s.add_dependency('simplecov', ['~> 0.7.1'])
      s.add_dependency('simplecov-console', ['~> 0.1.1'])
      s.add_dependency('minitest', ['~> 5.0.8'])
      s.add_dependency('minitest-debugger', ['~> 1.0.2'])
    end
  else
    s.add_dependency('rdoc', ['~> 4.0'])
    s.add_dependency('rake', ['~> 10.1.0'])
    s.add_dependency('hoe', ['~> 3.7.1'])
    s.add_dependency('hoe-gemspec', ['~> 1.0.0'])
    s.add_dependency('hoe-bundler', ['~> 1.2.0'])
    s.add_dependency('simplecov', ['~> 0.7.1'])
    s.add_dependency('simplecov-console', ['~> 0.1.1'])
    s.add_dependency('minitest', ['~> 5.0.8'])
    s.add_dependency('minitest-debugger', ['~> 1.0.2'])
  end
end
