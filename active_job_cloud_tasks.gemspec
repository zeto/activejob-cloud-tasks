Gem::Specification.new do |s|
  s.name        = 'active_job_cloud_tasks'
  s.version     = '1.0.0'
  s.date        = '2019-07-01'
  s.summary     = "ActiveJob Adapter for Google Cloud Tasks"
  s.description = "ActiveJob Adapter for Google Cloud Tasks"
  s.authors     = ["Jose Goncalves"]
  s.email       = 'jose.goncalves@blackorange.pt'
  s.files       = ["lib/active_job/queue_adapters/cloud_tasks_adapter.rb"]
  s.homepage    = 'https://rubygems.org/gems/active_job_cloud_tasks'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'activejob'
  s.add_runtime_dependency 'google-cloud-tasks'
end
