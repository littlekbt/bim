lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bim/version'

Gem::Specification.new do |spec|
  spec.name          = 'bim'
  spec.version       = Bim::VERSION
  spec.authors       = ['littlekbt']
  spec.email         = ['kr.kubota.11@gmail.com']

  spec.summary       = 'bim is BigIP cli tool'
  spec.homepage      = 'https://github.com/littlekbt/bim'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables << 'bim'
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.20.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
