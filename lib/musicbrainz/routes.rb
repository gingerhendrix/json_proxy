
module Nowplaying
  module Musicbrainz
    module Routes
   
     get '/musicbrainz/artist.js' do

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
        id     = 'c0b2500e-0cef-4130-869d-732b23ed9df5'
        artist = query.get_artist_by_id(id, includes)
        
        urls = artist.get_relations({:target_type => MusicBrainz::Model::Relation::TO_URL})
        
        urls = urls.map { |rel| { MusicBrainz::Utils.remove_namespace(rel.type, MusicBrainz::Model::NS_REL_1) => rel.target } }
        
        urls.to_json
     end
    
    end
  end
end 
