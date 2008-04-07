
  var $ = function(id){ return document.getElementById(id) };

  var now_playing;

  function get_recent_tracks(username){
    alert("Username: " + username);
    var d = loadJSONDoc("/audioscrobbler/recent_tracks.js", {username : username});
    d.addCallback(update_recent_tracks);
    return d;
  }

  function update_recent_tracks(recent_tracks){
    now_playing = recent_tracks[0];
    $("track").innerHTML = now_playing.name;
    $("album").innerHTML = now_playing.album;
    $("artist").innerHTML = now_playing.artist;
    
    get_album_info(now_playing.artist, now_playing.album);
    get_similar_artists(now_playing.artist);
    get_top_albums(now_playing.artist);
  };


  function get_album_info(artist, album){
    var d = loadJSONDoc("/audioscrobbler/album_info.js", {artist: artist, album : album});
    d.addCallback(update_album_info);
    return d;
  }

  function update_album_info(album){
    $("album_reach").innerHTML = album.reach;
    $("album_image").src = album.image_small;
    
    $("album_track_listing").innerHTML = "";
    
    var tracks_ol = document.createElement("ol");
    
    album.tracks.forEach(function(track){ 
      var relative_reach = (track.reach/album.reach)
      
      var track_li = document.createElement("li");
      var track_reach_bar = create_bar(relative_reach);
      track_li.innerHTML = track.name + " (" + Math.floor( relative_reach*100) + "%)";
      track_li.appendChild(track_reach_bar);
      tracks_ol.appendChild(track_li);
    });
    
    $("album_track_listing").appendChild(tracks_ol);        
  }

  function create_bar(float_value){
     var bar = document.createElement("span");
     bar.setAttribute("class", "bar");
     bar.style.paddingRight = Math.floor( float_value*100 ) + "px";
     
      var green_component = float_value * 2;
      green_component = green_component < 1.0 ? green_component : 1.0;
      var red_component= 2.0 - (float_value * 2.0);
      red_component = red_component < 0.0 ? 0.0 : red_component;
      red_component =  red_component > 1.0 ? 1.0 : red_component;
      bar.style.backgroundColor = Color.fromRGB(red_component, green_component, 0).toHexString();

      return bar;
  }






  function get_similar_artists(artist){
    var d = loadJSONDoc("/audioscrobbler/similar_artists.js", {artist: artist});
    d.addCallback(update_similar_artists);
    return d;
  }

  function update_similar_artists(similar_artists){
    $("similar_artists_list").innerHTML = "";

    similar_artists.slice(0, 10).forEach(function(sim){
      similar_li = document.createElement("li");
      similar_li.innerHTML = sim.name + " (" + sim.match + "%)";

      var similarity_bar = create_bar(sim.match/100);
      similar_li.appendChild(similarity_bar);
   
      $("similar_artists_list").appendChild(similar_li);
    });
  }

  function get_top_albums(artist){
    var d = loadJSONDoc("/audioscrobbler/top_albums.js", {artist: artist});
    d.addCallback(update_top_albums);
    return d;
  }

  function update_top_albums(top_albums){
    $("top_albums_list").innerHTML = "";
    var max_reach = top_albums[0].reach;
    top_albums.slice(0, 10).forEach(function(album){
      album_li = document.createElement("li");
      album_li.innerHTML = album.name + " (" + Math.round(100*(album.reach/max_reach)) + "%)";
      
      var reach_bar = create_bar((album.reach/max_reach));
      album_li.appendChild(reach_bar);

      
      $("top_albums_list").appendChild(album_li);
    });
  }; 

