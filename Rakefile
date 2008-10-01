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
require 'lib/json_proxy'

$:.unshift File.dirname(__FILE__) + "/tasks/lib"

Dir['tasks/**/*.rake'].each { |rake| load rake }



