
function RecentTracksDatasource(username){
  this.username = username;

  this.makeProp("recent_tracks");
  
  this.update = function(){
    var d = loadJSONDoc("/audioscrobbler/recent_tracks.js", {username : this.username});
    d.addCallback(bind(this.onUpdate, this));
    return d
  }
  
  this.onUpdate = function(response){
    this.recent_tracks(response);
  }

}

RecentTracksDatasource.prototype = new DataBean();
