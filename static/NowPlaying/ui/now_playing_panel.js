
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
  
  datasource.connect("track", this, "onTrackChange");
  datasource.connect("album", this, "onAlbumChange");
  datasource.connect("artist", this, "onArtistChange");
  
}
