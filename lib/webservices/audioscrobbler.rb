

np_namespace "audioscrobbler" do |ns|
  
  ns.route 'user_info', [:username] do |username|
    user = Scrobbler::User.new(username)
    user.load_profile
    user
  end

  ns.route 'recent_tracks', [:username], :cache_expiry => 30 do |username| 
   {:recent_tracks => Scrobbler::User.new(username).recent_tracks }
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
