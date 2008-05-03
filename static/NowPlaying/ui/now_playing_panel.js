    
function NowPlayingPanel(element, datasource){
  this.element = element;
  
  this.linkHtml(datasource, "track", "track");
  this.linkHtml(datasource, "album", "album");
  this.linkHtml(datasource, "artist", "artist");
  
}

NowPlayingPanel.prototype = new DataPanel();
