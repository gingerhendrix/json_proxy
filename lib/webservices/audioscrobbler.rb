

np_namespace "audioscrobbler" do |ns|
  ns.route 'recent_tracks', [:username], {:cache => false } do |username|
    Scrobbler::User.new(username).recent_tracks
  end
  
  ns.route 'album_info', [:artist, :album]  do |artist, album|
    Scrobbler::Album.new(artist, album, :include_info => true)
  end

  ns.route 'top_albums', [:artist]  do |artist|
     {:top_albums => Scrobbler::Artist.new(artist).top_albums }
  end

  ns.route "similar_artists", [:artist] do | artist |
     {:similar_artists => Scrobbler::Artist.new(artist).similar }
  end

end
