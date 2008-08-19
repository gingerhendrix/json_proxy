$:.unshift File.dirname(__FILE__)
require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'zlib'
require 'cgi'

require 'base'
require 'artist'
require 'label'
require 'release'
require 'simple_release'
require 'format'
require 'image'
require 'track'
require 'contributor'
require 'search'


module Discogs
  VERSION = '1.0.0'
  API_VERSION = '1.0'
end
