

get '/audioscrobbler/recent_tracks.js' do
  user = Scrobbler::User.new(params[:username])
  json_p user.recent_tracks
end	

np_namespace "audioscrobbler" do |ns|

  ns.route 'album_info', [:artist, :album]  do |artist, album|
    Scrobbler::Album.new(artist, album, :include_info => true)
  end

  ns.route 'top_albums', [:artist]  do |artist|
     Scrobbler::Artist.new(artist).top_albums
  end

  ns.route "similar_artists", [:artist] do | artist |
    Scrobbler::Artist.new(artist).similar
  end

end
