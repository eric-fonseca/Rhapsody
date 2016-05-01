// UI component at the center of the ControlCenter
class CenterControl extends Control{
  float sw, tr;
  color cPrimary, cSecondary;
  boolean isDrawingIn = false;
  boolean isDrawingOut = false;
  
  final float frameLength = 25;
  final float animationCutoff = 2.5;
  
  CenterControl(float x_, float y_, float r_, float sw_, color c1_, color c2_){
    super(x_, y_, r_, 1);
    sw = sw_;
    tr = 0;
    cPrimary = c1_;
    cSecondary = c2_;
  }
  
  void animate(){
    if(animating){
      if(!phaseSwitch && !phases[0]){
        phaseSwitch = true;
        phases[0] = true; 
      } else if(phases[0]){
        tr += (r - tr)/ frameLength;
        drawCenterControl(tr);
        
        if(r - tr < animationCutoff){
          phases[0] = false;
          isDrawingOut = true;
          animating = false;
        }
      }
    } else {
      drawCenterControl(r);
    }
  }
  
  void drawCenterControl(float r_){
    pushMatrix();
    translate(x,y);
    stroke(cPrimary);
    strokeWeight(sw);
    if(selection){
      fill(cPrimary);
    } else {
      fill(0);
    }
    ellipse(0,0,r_*2,r_*2);
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
