
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "demobank-client"
  spec.version       = 0.1.0
  spec.authors       = ["flymypie"]
  spec.email         = ["flymaipie@gmail.com"]

  spec.summary       = %q{HTTP client for DemoBank}
  spec.description   = %q{DemoBank client allows to login and get account information}
  spec.homepage      = "https://github.com/fly49/demobank-client"
  spec.license       = "MIT"

  spec.files         = ["lib/demobank-client.rb"]
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'faraday', "~> 0.15.3" 
  spec.add_dependency 'faraday-cookie_jar', "~> 0.0.6"
  spec.add_dependency 'nokogiri', "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
