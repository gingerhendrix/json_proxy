
module NowPlaying
  module Audioscrobbler
    module Routes
      #include NowPlaying::Utils::JsonP
      
      get '/audioscrobbler/recent_tracks.js' do
        user = Scrobbler::User.new(params[:username])
        json_p user.recent_tracks
      end	
      
        
      get '/audioscrobbler/album_info.js' do
        album = Scrobbler::Album.new(params[:artist], params[:album], :include_info => true)
        json_p album
      end

      get '/audioscrobbler/top_albums.js' do
        artist = Scrobbler::Artist.new(params[:artist])
        json_p artist.top_albums
      end

      get '/audioscrobbler/similar_artists.js' do
       artist = Scrobbler::Artist.new(params[:artist])
       json_p artist.similar
      end    
    end
  end
end

