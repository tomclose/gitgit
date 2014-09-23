# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitgit/version'

Gem::Specification.new do |spec|
  spec.name          = "gitgit"
  spec.version       = Gitgit::VERSION
  spec.authors       = ["Tom Close"]
  spec.email         = ["tom.close@cantab.net"]
  spec.summary       = %q{A simple wrapper around git to make it more accessible to beginners.}
  spec.description   = %q{Gitgit provides a reduced set of commands that make it easy for beginners to use git to version control their projects.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'thor', '~> 0.19.1'
  spec.add_runtime_dependency 'git', '~> 1.2.8'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
