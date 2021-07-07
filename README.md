# activejob-cloud-tasks
ActiveJob Google Cloud Tasks adapter

Configure adapter by adding to your rails config environment file:

```
  config.active_job.queue_adapter = ActiveJob::QueueAdapters::CloudTasksAdapter.new \
    project_id: '<project-id>',
    location_id: '<location-id>',
    http_target: 'https://<your-public-accessable-url>/jobs'
```
