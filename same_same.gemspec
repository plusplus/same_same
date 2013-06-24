# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'same_same/version'

Gem::Specification.new do |gem|
  gem.name          = "same_same"
  gem.version       = SameSame::VERSION
  gem.authors       = ["Julian Russell"]
  gem.email         = ["julian@myfoodlink.com"]
  gem.description   = %q{Implementation of ROCK and DBSCAN clustering algorithms}
  gem.summary       = %q{Implementation of ROCK and DBSCAN clustering algorithms}
  gem.homepage      = "https://github.com/plusplus/same_same"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('pry-debugger')  
  gem.add_development_dependency('colored') 
end
