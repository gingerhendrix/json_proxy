
function SimilarArtistsPanel(element, datasource){

  this.onChange = function(similar_artists){
    element.innerHTML = "";

    similar_artists.slice(0, 10).forEach(function(sim){
      var similar_li = document.createElement("li");
      similar_li.innerHTML = sim.name + " (" + sim.match + "%)";

      //var similarity_bar = create_bar(sim.match/100);
      //similar_li.appendChild(similarity_bar);
   
      $("similar_artists_list").appendChild(similar_li);
    });
  
  }

  datasource.connect("similar_artists", this, "onChange");
}
