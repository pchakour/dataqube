# encoding: utf-8
Gem::Specification.new do |gem|
  gem.name        = "fluent-plugin-dataqube"
  gem.description = "Filter plugin to execute ruby code with dataqube libs"
  gem.homepage    = "https://github.com/pchakour/dataqube"
  gem.summary     = "We advice to not use this plugin directly"
  gem.version     = File.read("VERSION").strip
  gem.authors     = ["Pharès CHAKOUR"]
  gem.email       = "chakour.phares@gmail.com"
  gem.license     = 'Apache-2.0'
  gem.files       = Dir["Gemfile", "lib/**/*"]
  gem.test_files  = []
  gem.executables = []
  gem.require_paths = ['lib']

  gem.add_dependency "fluentd", [">= 1.0", "< 2"]
  gem.add_development_dependency("test-unit", ["~> 3.4.0"])
end