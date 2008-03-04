require 'rubygems'
require File.dirname(__FILE__) + '/vendor/gems/sinatra-0.1.7/lib/sinatra.rb'
require 'open-uri'

require 'json/pure'
require 'json/add/core'
require 'json/add/rails'

require 'hpricot'
require 'scrobbler'

get '/' do
  File.open("nowplaying.html").read
end

static '/static', 'static'

get '/recent_tracks.js' do
  user = Scrobbler::User.new('gingerhendrix')

  tracks = user.recent_tracks.map { |t| 
    { :artist => t.artist,
      :album => t.album,
      :name => t.name,
      :date => t.date
     }
  }
  JSON.generate(tracks)
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
  JSON.generate(album_info)

end

get '/top_albums.js' do
  artist = Scrobbler::Artist.new(params[:artist])

  top_albums = artist.top_albums.map { |a| { :reach => a.reach, :name => a.name } }
 
  JSON.generate(top_albums)
end

get '/similar_artists.js' do
 artist = Scrobbler::Artist.new(params[:artist])

 similar_artists = artist.similar.map { |a| { :match => a.match, :name => a.name } }
 
 JSON.generate(similar_artists)
end
