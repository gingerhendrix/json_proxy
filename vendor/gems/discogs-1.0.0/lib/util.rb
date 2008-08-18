module Discogs
  class Util < Base
    class << self
      def run!
        if ARGV.size < 1
          usage
        end
        search = Discogs::Search.new(ARGV.join(' '))
        puts search.best_match
      end

      def usage
        puts "Usage:\n\tdiscogs Broken Social Scene"
        exit
      end
      
    end
  end
end
