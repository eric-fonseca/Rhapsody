// Base class for UI components
class Control{
  float x, y, r;
  int p;
  boolean selection = false;
  boolean pressed = false;
  boolean animating = false;
  boolean phaseSwitch = false;
  boolean[] phases;
  
  Control(float x_, float y_, float r_, int p_){
    x = x_;
    y = y_;
    r = r_;
    p = p_; // Number of intro phases
    
    // generating array of phases
    phases = new boolean[p];
    for(int i = 0; i < p; i++){
      phases[i] = false;
    }
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
