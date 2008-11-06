require 'erb'
require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_html'



desc 'Generate website files'
task :website_generate => :ruby_env do
  # Stolen/Adapted from newgem and its txt2html script
  #
  
  template = File.join(File.dirname(__FILE__), '/../website/template.html.erb')
  template = ERB.new(File.open(template).read)
  
  class Time
    def pretty
      return "#{mday}#{mday.ordinal} #{strftime('%B')} #{year}"
    end
  end
  
  class Fixnum
    def ordinal
      # teens
      return 'th' if (10..19).include?(self % 100)
      # others
      case self % 10
      when 1: return 'st'
      when 2: return 'nd'
      when 3: return 'rd'
      else    return 'th'
      end
    end
  end
  
  src = 'README.rdoc'
  
  formatter = SM::ToHtml.new
  markup = SM::SimpleMarkup.new
  body = markup.convert(File.read(src), formatter)

  title= "Json Proxy #{JsonProxy::VERSION}"
  version = JsonProxy::VERSION
  download = "http://rubyforge.org/projects/json-proxy"
  
  stat = File.stat(src)
  created = stat.ctime
  modified = stat.mtime
  
  File.open('website/index.html', "w") do |out|
    out << template.result(binding)
  end

end

desc 'Upload website files to gandrew.com'
remote_task :website_upload, :roles => [:app] do
 
  date_stamp = Time.now.strftime("%Y%m%d")
  last_release = run("ls #{DEPLOY_ROOT}/rels | sort -r | head -n 1").chomp

  if last_release =~ /#{date_stamp}\-(\d+)/
      serial = $1.to_i + 1
  else
      serial = 0 
  end

  rel = ("%d-%02d" % [date_stamp, serial])
  rel_dir = "#{DEPLOY_ROOT}/rels/#{rel}"
  
  run "sudo mkdir -p #{rel_dir}"
  run "sudo chown ga:ga #{rel_dir}"
  rsync 'website/', "#{rel_dir}/"
  run "sudo ln -s -f -T #{rel_dir} #{DEPLOY_ROOT}/current"
end

desc "Upload website files to rubyforge"
task :website_rubyforge do
  cd "website"
  sh "scp -r . rubyforge.org:#{RUBYFORGE_ROOT}"
  cd ".."
end


desc 'Generate and upload website files'
task :website => [:website_generate, :website_upload, :website_rubyforge]
