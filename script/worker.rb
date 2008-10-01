require 'rubygems'

require 'net/http'

require File.dirname(__FILE__) + '/../lib/queue/queue'
require File.dirname(__FILE__) + '/../lib/queue/queue_daemon'

worker = UrlQueue::QueueDaemon.new

sleeping = false

puts "Worker started"

loop do
  processed = worker.process
  if processed == 0 && !sleeping
    sleeping = true
    puts "Queue empty \n"
  elsif processed > 0
    puts "Processed #{processed}\n"
    sleeping = false
  end
  sleep(1)
end
