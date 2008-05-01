


function create_bar(float_value){
   var bar = document.createElement("span");
   bar.setAttribute("class", "bar");
   bar.style.paddingRight = Math.floor( float_value*100 ) + "px";
   
    var green_component = float_value * 2;
    green_component = green_component < 1.0 ? green_component : 1.0;
    var red_component= 2.0 - (float_value * 2.0);
    red_component = red_component < 0.0 ? 0.0 : red_component;
    red_component =  red_component > 1.0 ? 1.0 : red_component;
    bar.style.backgroundColor = Color.fromRGB(red_component, green_component, 0).toHexString();

    return bar;
}
