
Utils.namespace("NowPlaying.data", { 
  NowPlayingDatasource : function (recentTracksDatasource){
    this.makeProp("album");
    this.makeProp("track");
    this.makeProp("artist");
    
    this.onUpdate = function(recent_tracks){
      var now_playing = recent_tracks[0];
      this.track(now_playing.name);
      this.artist(now_playing.artist);
      this.album(now_playing.album);
      
    }
     
    recentTracksDatasource.connect("recent_tracks", this, "onUpdate");

 }
});

NowPlaying.data.NowPlayingDatasource.prototype = new NowPlaying.utils.DataBean();
