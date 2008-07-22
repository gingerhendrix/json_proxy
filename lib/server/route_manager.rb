require 'singleton'

module Server
  class RouteManager 
    include Singleton
    
    def initialize
      @map = Hash.new
    end
       
    def route_for(path)
      namespace = path.slice /\/(.*)\/(.*)\.(.*)$/, 1
      name = path.slice /\/(.*)\/(.*)\.(.*)$/, 2
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

    def register_route(namespace, name, route)
      if !@map.key? namespace
        @map[namespace] = Hash.new
      end
      @map[namespace][name] = route
      puts "Registered #{namespace}/#{name}\n"
    end

  end
end
