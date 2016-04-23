// UI component at the center of the ControlCenter
class CenterControl extends Control{
  float sw;
  color cPrimary, cSecondary;
  
  CenterControl(float x_, float y_, float r_, float sw_, color c1_, color c2_){
    super(x_, y_, r_);
    sw = sw_;
    cPrimary = c1_;
    cSecondary = c2_;
  }
  
  void drawCenterControl(){
    pushMatrix();
    translate(x,y);
    stroke(cPrimary);
    strokeWeight(sw);
    if(selection){
      fill(cPrimary);
    } else {
      fill(0);
    }
    ellipse(0,0,r*2,r*2);
    popMatrix(); 
  }
  
  // Overriding press function
  void detectPress(float x_, float y_){
    if(dist(x_,y_,x,y) < r/2){
      pressed = true;
      selection = true;
    }
  }
  
  // Overriding drag function
  void detectDrag(float x_, float y_){
    if(dist(x_,y_,x,y) < r/2 && pressed){
      selection = true;
    } else {
      selection = false;
    }
  }
}
