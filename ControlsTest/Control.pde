// Base class for UI components
class Control{
  float x, y, r;
  boolean selection = false;
  boolean pressed = false;
  
  Control(float x_, float y_, float r_){
    x = x_;
    y = y_;
    r = r_;
  }
  
  void detectPress(float x_, float y_){
    if(dist(x_,y_,x,y) < r){
      pressed = true;
      selection = true;
    }
  }
  
  void detectDrag(float x_, float y_){
    if(dist(x_,y_,x,y) < r){
      selection = true;
    } else {
      selection = false;
    }
  }
  
  void detectRelease(){
    pressed = false;
    selection = false;
  }
}
