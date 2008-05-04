Utils.namespace("NowPlaying.ui", {
  AlbumInfoPanel : function(element, datasource){
    this.element = element;
    
    this.linkHtml(datasource, "album", "album");
      function log(a, n){
        return Math.log(a)/Math.log(n);
      }
    this.link(datasource, "reach", "reach", function(el, val){
      el.innerHTML = val;
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
