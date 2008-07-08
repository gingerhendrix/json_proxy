
np_namespace "musicbrainz" do |ns|

    ns.route 'artist_releases', [:artist_mbid] do |artist_mbid|
        includes = {
          :aliases      => false,
          :releases     => ['Album', 'Official'],
          :artist_rels  => false,
          :release_rels => true,
          :track_rels   => false,
          :label_rels   => false,
          :url_rels     => false
        }
        
        query  = MusicBrainz::Webservice::Query.new
        id     = artist_mbid
        artist = query.get_artist_by_id(id, includes)

        releases = artist.releases.map do |rel|
           { :title => rel.title, 
             :releases => rel.release_events.map { |ev| ev.date.to_s },
             :earliest_release_date => rel.earliest_release_date, 
             :earliest_release_event => rel.earliest_release_event } 
        end

        { :releases =>  releases}
    end

     ns.route 'artist_urls', [:artist_mbid] do |artist_mbid|

        includes = {
          :aliases      => false,
          :releases     => [], #['Album', 'Official'],
          :artist_rels  => false,
          :release_rels => false,
          :track_rels   => false,
          :label_rels   => false,
          :url_rels     => true
        }

        query  = MusicBrainz::Webservice::Query.new
        id     = artist_mbid
        artist = query.get_artist_by_id(id, includes)
        
        urls = artist.get_relations({:target_type => MusicBrainz::Model::Relation::TO_URL})
        
        urls = urls.map { |rel| { :rel => MusicBrainz::Utils.remove_namespace(rel.type, MusicBrainz::Model::NS_REL_1), :href => rel.target } }
               
        { :urls => urls}
     end
end 
