require 'rubygems'
begin
  require 'rake'
rescue LoadError
  puts 'This script should only be accessed via the "rake" command.'
  puts 'Installation: gem install rake -y'
  exit
end
require 'rake'
require 'rake/clean'
require 'rake/packagetask'


$:.unshift File.dirname(__FILE__) + "/lib"

APP_VERSION  = '0.3.1'
APP_NAME     = 'NowPlaying'

APP_ROOT     = File.expand_path(File.dirname(__FILE__))

DEPLOY_ROOT = "/var/web/projects/#{APP_NAME}"
ON_DEPLOY_RESTART = []
APP_SERVER = "linode.gandrew.com"
SVN_REPO = "svn+ssh://gandrew.com/home/1439/users/.home/repos/nowplaying/trunk"

Dir['tasks/**/*.rake'].each { |rake| load rake }




