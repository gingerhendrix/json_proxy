

np_namespace "discogs" do |ns|
    
    ns.route 'search', [:query], {:cache => false } do |name|
      search = Discogs::Search.new name

      { :results => search.results, :exactresults => search.exactresults, :best_match => search.best_match } 
    end
    
    ns.route 'artist', [:name], {:cache => false } do |name|
      artist = Discogs::Artist.new name
      { :name => artist.name, 
        :members => artist.members,
        :urls => artist.urls,
        :releases => artist.releases,
        :images => artist.images,
        :realname => artist.realname
      }
    end

    
end
