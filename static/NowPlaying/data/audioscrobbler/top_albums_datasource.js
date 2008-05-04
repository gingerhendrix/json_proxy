Utils.namespace("NowPlaying.data.audioscrobbler", {
  TopAlbumsDatasource : function(artist){
    this.artist = artist;
    
    this.makeProp("top_albums");
    
    this.update = function(){
      var d = loadJSONDoc("/audioscrobbler/top_albums.js", {artist : this.artist});
      d.addCallback(bind(this.onUpdate, this));
      return d
    }

    this.onUpdate = function(response){
      this.top_albums(response);
    }

  }
});

NowPlaying.data.TopAlbumsDatasource.prototype = new NowPlaying.utils.DataBean();
