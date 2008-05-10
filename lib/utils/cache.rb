require 'fileutils'

module Utils
  class Cache
    class << self
      attr_accessor :base_dir
    end
  
    def initialize(prefix)
      @base_dir = Cache.base_dir
      raise "Base dir doesn't exist" unless File.exists? @base_dir
      @base_dir += "/" + prefix
      FileUtils.mkpath(@base_dir) unless File.exists? @base_dir
    end
    
    def filename(key)
      @base_dir +  "/" + key + ".json"
    end
      
    def store(key, value)
      File.open filename(key), "w" do |file|
        file.write(value);
      end
    end
    
    def fetch(key)
      value = nil
      if File.exists? filename(key)
        File.open filename(key), "r" do |file|
          value = file.read
        end
      end
      value
    end
            
  end
end
