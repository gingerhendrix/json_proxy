
function DataBean(){
  this.properties = {};
  
  this.connect = function(name, obj, method){
    MochiKit.Signal.connect(this, name, obj, method);
  }
  
  this.makeProp = function(prop){
    
    this[prop] = function(val){
      if(val && val != this.properties[prop]){
        this.properties[prop] = val;
        MochiKit.Signal.signal(this, prop, val);              
      }
      return this.properties[prop];
    }
    
  }

}
