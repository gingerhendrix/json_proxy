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
require 'rake_remote_task'

$:.unshift File.dirname(__FILE__) + "/lib"
require 'json_proxy'

$:.unshift File.dirname(__FILE__) + "/tasks/lib"

role :app, "gandrew.com"
role :rubyforge, "rubyforge.org"

DEPLOY_ROOT = "/var/web/projects/json_proxy"
RUBYFORGE_ROOT = "/var/www/gforge-projects/json-proxy/"

Dir['tasks/**/*.rake'].each { |rake| load rake }



