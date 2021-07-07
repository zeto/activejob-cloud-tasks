require 'google/cloud/tasks'
require 'google/protobuf/timestamp_pb'
require 'google/protobuf/duration_pb'

module ActiveJob
  module QueueAdapters
    class CloudTasksAdapter
      def initialize(project_id: nil, location_id: nil, http_target: nil, timeout: nil)
        @project_id  = project_id
        @location_id = location_id
        @timeout     = timeout
        @http_target = http_target
      end

      def enqueue(job)
        create_cloud_task(job)
      end

      def enqueue_at(job, timestamp)
        create_cloud_task(job, timestamp)
      end

      private

      def create_cloud_task(job, timestamp = nil)
        @client ||= Google::Cloud::Tasks.cloud_tasks

        parent = @client.queue_path project: @project_id, location: @location_id, queue: job.queue_name

        task = {
          http_request: {
            url: @http_target,
            http_method: 'POST',
            body: Base64.strict_encode64(job.serialize.to_json)
          }
        }

        if timestamp
          task[:schedule_time] = Google::Protobuf::Timestamp.new(seconds: timestamp.to_i)
        end

        if @timeout
          task[:dispatch_deadline] = Google::Protobuf::Duration.new(seconds: @timeout.to_i)
        end

        Rails.logger.warn 'Logging Cloud Task Payload'
        Rails.logger.warn task
        @client.create_task({parent: parent, task: task})
      end
    end
  end
end
