require 'mock-thread/version'

Gem::Specification.new do |s|
  s.name = "mock-thread"
  s.version = MockThread::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0")
  s.authors = ["Joel VanderWerf"]
  s.date = Time.now.strftime "%Y-%m-%d"
  s.summary = "Use Fibers to test Thread code"
  s.description = "Use Fibers to test Thread code."
  s.email = "vjoel@users.sourceforge.net"
  s.extra_rdoc_files = ["README.md", "COPYING"]
  s.files = Dir[
    "README.md", "COPYING", "Rakefile",
    "lib/**/*.rb",
    "examples/**/*.rb",
    "test/**/*.rb"
  ]
  s.test_files = Dir["test/*.rb"]
  s.homepage = "https://github.com/vjoel/mock-thread"
  s.license = "BSD"
  s.rdoc_options = [
    "--quiet", "--line-numbers", "--inline-source",
    "--title", "MockThread", "--main", "README.md"]
  s.require_paths = ["lib"]
end
