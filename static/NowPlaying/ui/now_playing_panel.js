    
function NowPlayingPanel(element, datasource){

  this.onTrackChange = function(track){
    var trackEl = MochiKit.DOM.getElementsByTagAndClassName("span", "track", element)[0];
    trackEl.innerHTML = track;
  }
  
  this.onAlbumChange = function(album){
    var albumEl = MochiKit.DOM.getElementsByTagAndClassName("span", "album", element)[0];
    albumEl.innerHTML = album;
  }
  
  this.onArtistChange = function(track){
    var artistEl = MochiKit.DOM.getElementsByTagAndClassName("span", "artist", element)[0];
    artistEl.innerHTML = track;
  }
  
  this.onImageChange = function(image){
    var imageEl = MochiKit.DOM.getElementsByTagAndClassName("img", "album_image", element)[0];
    imageEl.src = image;
  }
  
  this.onReachChange = function(reach){
    var reachEl = MochiKit.DOM.getElementsByTagAndClassName("span", "album_reach", element)[0];
    reachEl.innerHTML = reach;
  }

  
  datasource.connect("track", this, "onTrackChange");
  datasource.connect("album", this, "onAlbumChange");
  datasource.connect("artist", this, "onArtistChange");
  datasource.connect("image", this, "onImageChange");
  datasource.connect("reach", this, "onReachChange");
}
