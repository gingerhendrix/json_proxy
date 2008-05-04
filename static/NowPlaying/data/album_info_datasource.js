
Utils.namespace("NowPlaying.data", { 
  AlbumInfoDatasource : function(npDatasource, aiDatasource){
    this.makeProp("reach");
    this.makeProp("image");
    this.makeProp("album");
    this.makeProp("track_listing");
    this.makeProp("artist");
    
    npDatasource.connect("album", this, this.album);
    npDatasource.connect("artist", this, this.artist);
    
    aiDatasource.connect("album_reach", this, this.reach);
    aiDatasource.connect("album_image", this, this.image);
    aiDatasource.connect("album_track_listing", this, this.track_listing);

  }
});

NowPlaying.data.AlbumInfoDatasource.prototype = new NowPlaying.utils.DataBean();
