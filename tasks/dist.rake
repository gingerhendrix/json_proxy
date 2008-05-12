
namespace :dist do

  desc "Builds the distribution"
  task :js do
    require 'protodoc'
    require 'fileutils'
   
    Dir.chdir(JS_SRC_DIR) do
      File.open(File.join(JS_SRC_DIR, "NowPlaying.js"), 'w+') do |dist|
        dist << Protodoc::Preprocessor.new("NowPlaying.js.erb")
      end
    end
  end
  
end
