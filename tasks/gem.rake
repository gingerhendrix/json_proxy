require 'rake/gempackagetask'


task :clean => :clobber_package

spec = Gem::Specification.new do |s|
  s.name                  = JsonProxy::NAME
  s.version               = JsonProxy::VERSION
  s.platform              = Gem::Platform::RUBY
  s.summary               = 
  s.description           = "A JSON webservices DSL/server"
  s.author                = "Gareth Andrew"
  s.email                 = 'gingerhendrix@gmail.com'
  s.homepage              = 'http://projects.gandrew.com/json_proxy'
  s.rubyforge_project     = 'json_proxy'
  s.has_rdoc              = true
  s.executables           = %w(json_proxy)

  s.required_ruby_version = '>= 1.8.5'
  
  s.add_dependency        'rack',         '>= 0.4.0'
  s.add_dependency        'starling',     '>= 0.9.8'
  s.add_dependency        'activesupport','>= 2.1.0'

  s.files                 = ['History.txt', 'Rakefile', 'README.rdoc' ) +
                            Dir.glob("{bin, lib,test, tasks}/**/*")
  
  s.require_path          = "lib"
  s.bindir                = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

task :tag_warn do
  puts "*" * 40
  puts "Don't forget to tag the release:"
  puts
  puts "  git tag -m 'Tagging Json Proxy' -a v#{JsonProxy::VERSION}"
  puts
  puts "or run rake tag"
  puts "*" * 40
end
task :tag do
  sh "git tag -m 'Tagging Json Proxy' -a v#{JsonProxy::VERSION}"
end
task :gem => :tag_warn

task :install => [:clobber, :compile, :package] do
  sh "#{SUDO} #{gem} install pkg/#{spec.full_name}.gem"
end

task :uninstall => :clean do
  sh "#{SUDO} #{gem} uninstall -v #{JsonProxy::VERSION} -x #{JsonProxy::NAME}"
end

def gem
  RUBY_1_9 ? 'gem19' : 'gem'
end
