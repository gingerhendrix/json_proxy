require 'singleton'

module Server
  class NamespaceManager 
    include Singleton
    
    def initialize
      @map = Hash.new
    end
       
    def handler_for(path)
      namespace = path.slice /\/(.*)\/(.*)/, 1
      name = path.slice /\/(.*)\/(.*)/, 2
      puts "Namespace: #{namespace}  name: #{name}  map: #{@map} \n"  
      if (@map.key? namespace)
        puts "Namespace found\n"
        if (@map[namespace].key? name)
            puts "Name found\n"
            @map[namespace][name]
        end
      else
        puts "Namespace not found"
      end
    end

    def register_handler(namespace, name, handler)
      if !@map.key? namespace
        @map[namespace] = Hash.new
      end
      @map[namespace][name] = handler        
      puts "Registered #{namespace}/#{name}\n"
    end

  end
end
