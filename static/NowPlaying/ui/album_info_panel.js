Utils.namespace("NowPlaying.ui", {
  AlbumInfoPanel : function(element, datasource){
    this.element = element;
    
    this.linkHtml(datasource, "album", "album");
    this.link(datasource, "reach", "reach", function(el, val){
      el.innerHTML = (Math.log(val) / Math.log(500000)).toFixed(1) ;
    });
    this.linkImage(datasource, "image", "album_image");    
    this.link(datasource, "track_listing", "track_listing_list", function(el, val){
      el.innerHTML = "";
      val.forEach(function(track){
        var li = document.createElement("li");
        li.innerHTML = track.name;
        el.appendChild(li);
      });
    });
  }
});

NowPlaying.ui.AlbumInfoPanel.prototype = new NowPlaying.ui.DataPanel();
