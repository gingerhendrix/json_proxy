%w{cgi rubygems hpricot active_support}.each { |x| require x }

require File.dirname(__FILE__) + '/scrobbler/base'

require File.dirname(__FILE__) + '/scrobbler/album'
require File.dirname(__FILE__) + '/scrobbler/artist'
require File.dirname(__FILE__) + '/scrobbler/chart'
require File.dirname(__FILE__) + '/scrobbler/user'
require File.dirname(__FILE__) + '/scrobbler/tag'
require File.dirname(__FILE__) + '/scrobbler/track'

require File.dirname(__FILE__) + '/scrobbler/rest'
require File.dirname(__FILE__) + '/scrobbler/version'
