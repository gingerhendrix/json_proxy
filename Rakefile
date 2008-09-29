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
require 'hoe'
require 'lib/json_proxy'
$:.unshift File.dirname(__FILE__) + "/tasks/lib"

APP_VERSION  = '0.5.0'
APP_NAME     = 'json_proxy'

APP_ROOT     = File.expand_path(File.dirname(__FILE__))

DEPLOY_ROOT = "/var/web/apps/#{APP_NAME}"
ON_DEPLOY_RESTART = []
APP_SERVER = "linode.gandrew.com"
#SVN_REPO = "svn+ssh://gandrew.com/home/1439/users/.home/repos/nowplaying/trunk"

Dir['tasks/**/*.rake'].each { |rake| load rake }

Hoe.new('JsonProxy', JsonProxy::VERSION) do |p|
  # p.rubyforge_name = 'JsonProxyx' # if different than lowercase project name
   p.developer('Gareth Andrew', 'me@gandrew.com')
end




