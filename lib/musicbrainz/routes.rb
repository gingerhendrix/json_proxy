
module Nowplaying
  module Musicbrainz
    module Routes
   
     get '/musicbrainz/artist_urls.js' do

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
        id     = params[:artist_mbid]
        artist = query.get_artist_by_id(id, includes)
        
        urls = artist.get_relations({:target_type => MusicBrainz::Model::Relation::TO_URL})
        
        urls = urls.map { |rel| { :rel => MusicBrainz::Utils.remove_namespace(rel.type, MusicBrainz::Model::NS_REL_1), :href => rel.target } }
               
        { :urls => urls}.to_json
     end
    
    end
  end
end 
