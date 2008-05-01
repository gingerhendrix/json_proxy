
function NowPlayingDatasource(recentTracksDatasource, albumInfoDatasource){
  this.makeProp("album");
  this.makeProp("track");
  this.makeProp("artist");
  this.makeProp("reach");
  this.makeProp("image");
  
  this.onUpdate = function(recent_tracks){
    var now_playing = recent_tracks[0];
    this.track(now_playing.name);
    this.artist(now_playing.artist);
    this.album(now_playing.album);
  }
  
  this.connect("album", this, function(){
    albumInfoDatasource.artist = this.artist();
    albumInfoDatasource.album = this.album();
    albumInfoDatasource.update();
  });
 
  recentTracksDatasource.connect("recent_tracks", this, "onUpdate");
  albumInfoDatasource.connect("album_reach", this, "reach");
  albumInfoDatasource.connect("album_image", this, "image");
}

NowPlayingDatasource.prototype = new DataBean();
