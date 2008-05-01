
function SimilarArtistsDatasource(artist){
  this.artist = artist;
  
  this.makeProp("similar_artists");
  
  this.update = function(){
    var d = loadJSONDoc("/audioscrobbler/similar_artists.js", {artist : this.artist});
    d.addCallback(bind(this.onUpdate, this));
    return d
  }

  this.onUpdate = function(response){
    this.similar_artists(response);
  }

}

SimilarArtistsDatasource.prototype = new DataBean();
