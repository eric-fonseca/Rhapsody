// Non-control class that merely acts as visual feedback
class Echo{
  float x, y, r, o, rr, or, sw;
  color cPrimary;
  boolean start = false;
  boolean isDynamic;

  Echo(float x_, float y_, float r_, float rr_, float or_, float sw_, color c_){
    x = x_;
    y = y_;
    r = r_;
    o = 255;
    rr = rr_;
    or = or_;
    sw = sw_;
    cPrimary = c_;
    isDynamic = false;
  }
  
  Echo(float x_, float y_, float r_, float sw_, color c_){
    x = x_;
    y = y_;
    r = r_;
    o = 255;
    sw = sw_;
    cPrimary = c_;
    isDynamic = true;
  }
    
    float getOpacity(){
      return o; 
    }
  
  void update(){
    if(start){
      o -= or;
      r += rr;
      if(o > 0){
        pushMatrix();
        stroke(cPrimary, o);
        strokeWeight(sw);
        noFill();
        ellipse(x,y,r,r);
        popMatrix();
      }
    }
  }
  
  void dynamicUpdate(float or_, float rr_){
    if(start){
      o -= or_;
      r = rr_;
      if(o > 0){
        pushMatrix();
        stroke(cPrimary, o);
        strokeWeight(sw);
        noFill();
        ellipse(x,y,r,r);
        popMatrix();
      }
    }
  }
}
