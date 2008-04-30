
function ArtistInfoDataSource(artist, album){
  this.artist = artist;
  this.album = album;
  
  this.makeProp("album_reach");
  this.makeProp("album_image");
  this.makeProp("album_track_listing");
  
  this.update = function(){
    var d = loadJSONDoc("/audioscrobbler/artist_info.js", {artist : artist, album : album});
    d.addCallback(bind(this.onUpdate, this));
    return d
  }

  this.onUpdate = function(album){
    this.album_reach(album.reach);
    this.album_image(album.image_small);
    this.album_track_listing(album.tracks);
  }

}
