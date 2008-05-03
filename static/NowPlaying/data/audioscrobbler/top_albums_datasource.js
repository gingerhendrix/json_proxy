
function TopAlbumsDatasource(artist){
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

TopAlbumsDatasource.prototype = new DataBean();
