# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
job_type :runner, "cd :path && bundle exec rails runner -e :environment ':task' :output"

every 1.days do
  runner 'DailyDigestJob.perform_now'
end

every 15.minute do
  runner 'NotificationJob.perform_now'
end

every 1.hour do
  rake 'ts:index'
end

# Learn more: http://github.com/javan/whenever
