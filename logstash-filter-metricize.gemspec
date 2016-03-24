Gem::Specification.new do |s|

  s.name            = 'logstash-filter-metricize'
  s.version         = '2.0.4'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = "The metricize filter is for transforming events with multiple metrics into multiple event each with a single metric."
  s.description     = "Metricize will take an event together with a list of metric fields and split this into multiple events, each holding a single metric."
  s.authors         = ["Elastic"]
  s.email           = 'christian.dahlqvist@elastic.co'
  s.homepage        = "http://logstash.net/"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 1.0"

  s.add_development_dependency 'logstash-devutils'

end

