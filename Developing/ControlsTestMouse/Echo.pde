// Non-control class that merely acts as visual feedback
class Echo{
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float opacityDecay = 10; // How quickly the echo's color alpha value decays each frame
  final float radiusRate = 5; // How quickly the radius of the echo increases each frame
  
  float x, y, r, o, sw;
  color primary;
  boolean start = false;

  Echo(float x_, float y_, float r_, float sw_, color primary_){
    x = x_;
    y = y_;
    r = r_;
    o = 255;
    sw = sw_;
    primary = primary_;
  }
    
    float getOpacity(){
      return o; 
    }
  
  void update(){
    if(start){
      o -= opacityDecay;
      r += radiusRate;
      if(o > 0){
        pushMatrix();
        stroke(primary, o);
        strokeWeight(sw);
        noFill();
        ellipse(x,y,r,r);
        popMatrix();
      }
    }
  }
}
