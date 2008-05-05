Utils.namespace("NowPlaying.ui", {
  ArtistInfoPanel : function(element, datasource){
    this.element = element;
    
    this.linkHtml(datasource, "artist", "artist");
    this.link(datasource, "wikipedia_url", "wikipedia_url", function(el, val){
      el.href = val;
    });
    this.linkHtml(datasource, "wikipedia_content", "wikipedia_content");
  
  }
});

NowPlaying.ui.ArtistInfoPanel.prototype = new NowPlaying.ui.DataPanel();
