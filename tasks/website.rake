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
  download = "http://rubyforge.org/projects/json_proxy"
  
  stat = File.stat(src)
  created = stat.ctime
  modified = stat.mtime
  
  File.open('website/index.html', "w") do |out|
    out << template.result(binding)
  end

end

desc 'Upload website files to rubyforge'
task :website_upload do
  host = "#{rubyforge_username}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{PATH}/"
  local_dir = 'website'
  sh %{rsync -aCv #{local_dir}/ #{host}:#{remote_dir}}
end

desc 'Generate and upload website files'
task :website => [:website_generate, :website_upload, :publish_docs]
