
np_namespace "musicbrainz" do |ns|
    
    ns.route 'artist_search', [:query] do |name|
      query  = MusicBrainz::Webservice::Query.new
      artists = query.get_artists :name => name, :limit => 10
      
      results = artists.map do |a|
        { :score => a.score,
          :artist_name => a.entity.name,
          :artist_mbid => a.entity.id.uuid
        }
      end
      
      {:results => results}
    end
    
    ns.route 'artist_members', [:artist_mbid] do |artist_mbid|
      includes = {
          :aliases      => false,
          :releases     => [],
          :artist_rels  => true,
          :release_rels => false,
          :track_rels   => false,
          :label_rels   => false,
          :url_rels     => false
      }

      query  = MusicBrainz::Webservice::Query.new
      id     = artist_mbid
      artist = query.get_artist_by_id(id, includes)
    
      relations = artist.get_relations :target_type => MusicBrainz::Model::Relation::TO_ARTIST
      { :relations => relations.map do |rel|
          {:type => MusicBrainz::Utils.remove_namespace(rel.type, MusicBrainz::Model::NS_REL_1),
           :mbid=> rel.target.id.uuid,
           :name => rel.target.name,
           :direction => rel.direction,
           :begindate => rel.target.begin_date.to_s,
           :enddate => rel.target.end_date.to_s } 
        end
      }
    end

    ns.route 'artist_releases', [:artist_mbid] do |artist_mbid|
        includes = MusicBrainz::Webservice::ArtistIncludes.new :aliases      => false,
                                                               :releases     => ['Album', 'Official'],
                                                               :artist_rels  => false,
                                                               :release_rels => true,
                                                               :track_rels   => false,
                                                               :label_rels   => false,
                                                               :url_rels     => false,
                                                               :release_events => true
        
        query  = MusicBrainz::Webservice::Query.new
        id     = artist_mbid
        artist = query.get_artist_by_id(id, includes)

        releases = artist.releases.map do |rel|
           { :artist => rel.artist.to_s,
             :artist_mbid => rel.artist.id.uuid,
             :title => rel.title, 
             :discs => rel.discs,
             :asin => rel.asin,
             :type => rel.types.map { |type| MusicBrainz::Utils.remove_namespace(type, MusicBrainz::Model::NS_MMD_1) },
             :release_events => rel.release_events.map { |ev| 
                                                   { :date => ev.date.to_s,
                                                          :barcode => ev.barcode,
                                                          :catalog_number => ev.catalog_number,
                                                          :country => ev.country,
                                                          :format => (!ev.format.nil? ? ev.format.map { |format| MusicBrainz::Utils.remove_namespace(format, MusicBrainz::Model::NS_MMD_1) } : [] ),
                                                          :label => (!ev.label.nil? ? ev.label.name : "")
                                                   }
                                                 },
          } 
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
