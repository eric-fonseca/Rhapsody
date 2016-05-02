// Base class for UI components, also acting as an seudo-interface
class Control{
  float x, y, r, sw;
  int p;
  boolean selection = false;
  boolean pressed = false;
  boolean animating = false;
  boolean phaseSwitch = false;
  boolean[] phases;
  ArrayList<Echo> echoes;
  
  Control(float x_, float y_, float r_, float sw_, int p_){
    x = x_;
    y = y_;
    r = r_;
    sw = sw_;
    p = p_; // Number of intro phases
    
    // generating array of phases
    phases = new boolean[p];
    for(int i = 0; i < p; i++){
      phases[i] = false;
    }
    
    // Creating echo arraylist
    echoes = new ArrayList<Echo>();
  }
  
  // Base methods to override
  // Some controls will have to be updated every frame
  void update(){}
  // Most controls will have intro-animations which will be written in this method
  void animate(){}
  // Every control will have to be drawn to the PApplet
  void drawControl(){}
    
  // Utility function to quickly draw all echoes associated with the control, as well as dynamically deleting echoes
  void drawEchoes(){
    for(int i = echoes.size() - 1; i >= 0; i--){
      if(echoes.get(i).getOpacity() > 0){
        echoes.get(i).update();
      } else {
        echoes.remove(i); 
      }
    } 
  }
  
  void detectPress(float x_, float y_, float r_){
    if(dist(x_,y_,x,y) < r_){
      pressed = true;
      selection = true;
    }
  }
  
  void detectDrag(float x_, float y_, float r_){
    if(dist(x_,y_,x,y) < r_){
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
