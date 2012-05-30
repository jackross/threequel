# -*- encoding: utf-8 -*-
require File.expand_path('../lib/threequel/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jack A Ross"]
  gem.email         = ["jack.ross@technekes.com"]
  gem.description   = %q{A SQL Utility Gem}
  gem.summary       = %q{A SQL Utility Gem}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "threequel"
  gem.require_paths = ["lib"]
  gem.version       = Threequel::VERSION
  gem.add_dependency "timer", "~> 0.1.7"
end