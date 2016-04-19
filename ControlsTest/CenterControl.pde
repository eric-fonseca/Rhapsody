// UI component at the center of the ControlCenter
class CenterControl{
  float x, y, r, sw;
  color cPrimary, cSecondary;
  boolean selected = false;
  
  CenterControl(float x_, float y_, float r_, float sw_, color c1_, color c2_){
    x = x_;
    y = y_;
    r = r_;
    sw = sw_;
    cPrimary = c1_;
    cSecondary = c2_;
  }
  
  void drawCenterControl(){
    pushMatrix();
    translate(x,y);
    stroke(cPrimary);
    strokeWeight(sw);
    if(selected){
      fill(cPrimary);
    } else {
      fill(0);
    }
    ellipse(0,0,r*2,r*2);
    popMatrix(); 
  }
  
  // Mouse event
  void passMouseDrag(float x_, float y_){
    if(dist(x_,y_,x,y) < r + sw/2){
      selected = true;
    } else {
      selected = false;
    }
  }
  
  void passMouseRelease(){
    selected = false;
  }
}
