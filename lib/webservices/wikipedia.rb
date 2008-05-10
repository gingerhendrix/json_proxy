

np_namespace 'wikipedia' do |ns|
      
  ns.route 'content', [:url], :cache_key => Proc.new { |url| url[%r{^http://en.wikipedia.org/wiki/(.*)$}, 1].gsub(/[^\w]/, '_')  } do |url|
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
    
    {:innerHTML => content.to_html}
  end

end
