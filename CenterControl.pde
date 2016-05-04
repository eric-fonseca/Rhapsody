// UI component at the center of the ControlCenter
class CenterControl extends Control{
  color cPrimary, cSecondary;
  
  // Animation variables
  float tr;
  boolean isDrawingIn = false;
  boolean isDrawingOut = false;
  
  // Animation Constants
  final float frameLength = 25;
  final float animationCutoff = 2.5;
  
  CenterControl(float x_, float y_, float r_, float sw_, color c1_, color c2_){
    super(x_, y_, r_, sw_, 1);
    cPrimary = c1_;
    cSecondary = c2_;
    tr = 0;
  }
  
  void animate(){
    super.animate();
    if(animating){
      if(!phaseSwitch && !phases[0]){
        phaseSwitch = true;
        phases[0] = true; 
      } else if(phases[0]){
        tr += (r - tr)/ frameLength;
        this.drawControl(tr);
        
        if(r - tr < animationCutoff){
          phases[0] = false;
          isDrawingOut = true;
          animating = false;
        }
      }
    } else {
      this.drawControl(r);
    }
  }
  
  void drawControl(float r_){
    super.drawControl();
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
}
