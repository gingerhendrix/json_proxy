
require File.dirname(__FILE__) + '/vendor/gems/sinatra-0.1.7/lib/sinatra.rb'

require 'rubygems'

#require 'json'
#require 'json/add/rails'

require 'hpricot'
require 'scrobbler'


get '/' do
  File.open("nowplaying.html").read
end

static '/static', 'static'

get '/recent_tracks.js' do
  
  user = Scrobbler::User.new('gingerhendrix')

  tracks = user.recent_tracks.map do |t| 
    { :artist => t.artist,
      :album => t.album,
      :name => t.name,
      :date => t.date
     }
  end
  
  tracks.to_json
end	

get '/album_info.js' do
  album = Scrobbler::Album.new(params[:artist], params[:album], :include_info => true)

  album_info = {:artist => album.artist,
           :name => album.name,
           :reach => album.reach,
           :url => album.url,
           :image => album.image(:small),
           :release_date => album.release_date,
           :tracks =>  album.tracks.map { |t| 
                                         { :name => t.name,
                                            :reach => t.reach,
                                            :url => t.url
                                          }
                                        }
  }
  album_info.to_json

end

get '/top_albums.js' do
  artist = Scrobbler::Artist.new(params[:artist])

  top_albums = artist.top_albums.map { |a| { :reach => a.reach, :name => a.name } }
 
  top_albums.to_json
end

get '/similar_artists.js' do
 artist = Scrobbler::Artist.new(params[:artist])

 similar_artists = artist.similar.map { |a| { :match => a.match, :name => a.name } }
 
 similar_artists.to_json
end
