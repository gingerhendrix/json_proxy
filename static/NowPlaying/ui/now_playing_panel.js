Utils.namespace("NowPlaying.ui", {    
  NowPlayingPanel : function(element, datasource){
    this.element = element;
    
    this.linkHtml(datasource, "track", "track");
    this.linkHtml(datasource, "album", "album");
    this.linkHtml(datasource, "artist", "artist");
    
  }
});

NowPlaying.ui.NowPlayingPanel.prototype = new NowPlaying.ui.DataPanel();
