Gem::Specification.new do |s|
  s.name          = "dataqube"
  s.version       = File.read("VERSION")
  s.summary       = "Dataqube parser"
  s.description   = "This parser is based on fluentd"
  s.authors       = ["Phares Chakour"]
  s.email         = "chakour.phares@gmail.com"
  s.files         = Dir["src/dataqube-parser/**/*", "examples/**/*", "vendor/**/*"]
  s.homepage      = "https://github.com/pchakour/dataqube"
  s.license       = "Apache-2.0"
  s.executables << 'dataqube'
end