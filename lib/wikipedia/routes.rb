

module NowPlaying
  module Wikipedia
    module Routes
      
      get '/wikipedia/content.js' do
        url = params[:url]
        doc = Hpricot open(url)

        para = (doc/'#bodyContent p').first 

        elements = []
        while !para.nil? && para.name == "p"
          elements << para
          para = para.next_sibling
        end
        
        content = Hpricot::Elements.new elements
        
        #change /wiki/ links to point to full wikipedia path
        (content/:a).each do |link|
          unless link['href'].nil?
            if link['href'] =~ %r!^/wiki/!
              link.swap("<a href='#{link['href'].sub('/wiki/', 'http://en.wikipedia.org/wiki/')}'>#{link.innerHTML}</a>")
            end
          end
        end
        
         json_p :innerHTML => content.to_html 
      end 
      
    end
  end
end
