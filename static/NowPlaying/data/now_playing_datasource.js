
function NowPlayingDatasource(username){
  this.makeProp("album");
  this.makeProp("track");
  this.makeProp("artist");

  this.update = function(){
    var d = loadJSONDoc("/audioscrobbler/recent_tracks.js", {username : username});
    d.addCallback(bind(this.onUpdate, this));
    return d;
  }
  
  this.onUpdate = function(recent_tracks){
    var now_playing = recent_tracks[0];
    this.track(now_playing.name);
    this.artist(now_playing.artist);
    this.album(now_playing.album);
  }
}

NowPlayingDatasource.prototype = new DataBean();
