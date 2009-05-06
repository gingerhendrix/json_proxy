require 'singleton'

module Server
  class RouteManager 
    include Singleton
    
    def initialize
      @map = Hash.new
      @log = Logging.logger[self]
    end
       
    def route_for(path)
      namespace = path.slice /\/(.*)\/(.*)\.(.*)$/, 1
      name = path.slice /\/(.*)\/(.*)\.(.*)$/, 2
      @log.info "Namespace: #{namespace}  name: #{name}  map: #{@map}"  
      if (@map.key? namespace)
        @log.info "Namespace found"
        if (@map[namespace].key? name)
          @log.info "Name found"
          return @map[namespace][name]
        end
      else
        @log.info "Namespace not found"
        return nil
      end
    end

    def register_route(namespace, name, route)
      if !@map.key? namespace
        @map[namespace] = Hash.new
      end
      @map[namespace][name] = route
      @log.info "Registered #{namespace}/#{name}\n"
    end

  end
end
