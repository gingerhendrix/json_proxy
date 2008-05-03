
function DataPanel(){
  this.link = function(datasource, topic, elementClass, fn){
     datasource.connect(topic, this, function(val){
      var elements = MochiKit.DOM.getElementsByTagAndClassName("*", elementClass, this.element);
      elements.forEach(function(el){
        fn.apply(this, [el, val]);
      });
    });
  }

  this.linkHtml = function(dataSource, topic, elementClass){
    this.link(dataSource, topic, elementClass, function(el, val){ el.innerHTML = val; });
  }
  
  this.linkImage = function(dataSource, topic, elementClass){
    this.link(dataSource, topic, elementClass, function(el, val){ el.src = val; });
  }
}
