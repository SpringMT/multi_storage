# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "multi_storage"
  spec.version       = "0.0.1"
  spec.authors       = ["SpringMT"]
  spec.email         = ["today.is.sky.blue.sky@gmail.com"]
  spec.summary       = %q{Store Files for multiple devices}
  spec.description   = %q{Store Files for multiple devices}
  spec.homepage      = "https://github.com/SpringMT/multi_storage"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
