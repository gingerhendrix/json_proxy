require 'rubygems'
require 'rack'
require 'json'
require 'json/add/core' #Converters for date, time, range etc
require 'json/add/rails' #Basic converter for object
require 'activesupport'

require 'configatron'

module JsonProxy
  VERSION = '0.5.1'
  NAME = "json_proxy"
  APP_VERSION = 2
end


require 'utils/json.rb'

require 'server/default_config.rb'

require 'server/handlers/handler.rb'
require 'server/handlers/argument_validation_handler.rb'
require 'server/handlers/cache_handler.rb'
require 'server/handlers/exception_handler.rb'
require 'server/handlers/json_handler.rb'
require 'server/handlers/queue_handler.rb'
require 'server/handlers/route_handler.rb'

require 'server/server.rb'
require 'server/route.rb'
require 'server/route_manager.rb'
require 'server/dsl.rb'
require 'server/json_request.rb'
require 'server/json_response.rb'

require 'queue/queue.rb'
require 'queue/queue_daemon.rb'

require 'utils/couch_cache.rb'
require 'utils/couch_server.rb'

