class ControlCenter{
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float centerCircleRatio = 0.5; // Relative radius ratio of the colored circle within the center of the class
  
  final float outerRingRatio = 1.0; // Relative radius ratio of the outer dot path
  final float outerRingRotate = -0.0010; // The speed of which the outer dot path rotates
  
  final float innerRingRatio = 0.5; // Relative radius ratio of the inner dot path
  final float innerRingRotate = 0.0015; // Relative radius ratio of the inner dot path
  
  CenterCircle centerCircle;
  DotPath outer, inner;
  Control[] controls;
  
  float x, y, r; // x-value, y-value, class wide radius
  int nc; // number of controls
  int cri, cli; // current right index, current left index
  boolean rsc, lsc; // right selection check, left selection check

  ControlCenter(float x_, float y_, float r_, int nc_){
    x = x_; // x value of the center of the class
    y = y_; // y value of the center of the class
    r = r_; // radius value for the class
    nc = nc_; // Number of controls for the class
    controls = new Control[nc];
    
    // Creating classes
    centerCircle = new CenterCircle(x,y,r*centerCircleRatio, 8, color(247, 255, 58), color(255,46,135));
    outer = new DotPath(x,y,r*outerRingRatio,5,color(255, 202), 30, outerRingRotate);
    inner = new DotPath(x,y,r*innerRingRatio,5,color(255, 202), 20, innerRingRotate);
    for(int i = 0; i < nc; i++){
      float temp = 2 * PI / nc;
      Control c = new Control(x,y,r,i * temp - PI,inner,outer,5,color(247, 255, 58),color(255,46,135));
      controls[i] = c;
    }
  }
  
  // This function draws all of the classes, built intending it to be run every frame. Call within Draw()
  void drawAll(){
    outer.drawDotPath(); 
    inner.drawDotPath();
    centerCircle.drawCenterCircle();
    
    splitControls();
    
    for(int i = 0; i < nc; i++){
      limitSelections(controls[i], i);
      controls[i].update();
      controls[i].drawControl();
    }
    
    if(!rsc){
      cri = -1;
    }
    
    if(!lsc){
      cli = -1;
    }
  }
  
    // This function causes there to only allow one control be to selected on each side at a given moment.
    void limitSelections(Control c, int i){
      if(controls[i].getSelected() == true){
        if(c.getDirection() == "right"){
          if(cri != -1){
            if(i != cri){
              c.setSelected(false); // refuse to select
              controls[cri].addEcho();
            } 
            rsc = true;
          } else { // cri does not have index
            cri = i;
            rsc = true;
          }
        }
        
        if(c.getDirection() == "left"){
          if(cli != -1){
            if(i != cli){
              c.setSelected(false); // refuse to select
              controls[cli].addEcho();
            }
            lsc = true;
          } else { // cli does not have index
            cli = i;
            lsc = true;
          }
        }
      } else { // Current control is not selected, check if users unselected cri/cli
        if(cri == i){
          cri = -1; 
        }
        if(cli == i){
          cli = -1;
        }
      }
    }
  
    // This function causes Controls that drift too close together to move apart from each other autonomously
    // This fixes the issue if controls become difficult to select individually if they stack on top of each other.
    void splitControls(){
      
      // Constant used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
      final float minAngleDifference = PI/6; // If differnce of two controls are within this range function gets called
      final float repellingForce = PI/11; // The amount that controls get pushed away from each other. Should be more than the half of minAngleDifference
      
      for(int i = 0; i < nc; i++){
        for(int u = i; u < nc; u++){
          if(u == i){
            continue;
          }
          
          // Note that function only runs if both controls are in an unselected state
          if(controls[i].getSelected() == false && controls[u].getSelected() == false){
            boolean a1B = false; 
            boolean a2B = false;
            Control c1 = controls[i];
            Control c2 = controls[u];
            float a1 = c1.getAngle() + PI;
            float a2 = c2.getAngle() + PI;
            if(Math.abs(Math.abs(a1) - Math.abs(a2)) < minAngleDifference){
              if(a1 > a2){
                pushControls(a1,c1,repellingForce);
                pushControls(a2,c2,-repellingForce);
              } else {
                pushControls(a1,c1,-repellingForce);
                pushControls(a2,c2,repellingForce);
              }
            }
          }
        }
      }
    }
    
      // This function is only called in SplitControls() as an utility function
      void pushControls(float a, Control c, float t){
        a = a + t - PI;
        if(t > 0 && a > PI){
          a -= 2 * PI;
        }
        if(t < 0 && a < -PI){
         a += 2 * PI; 
        }
        c.setAngle(a);
      }
  
  // Function to relay mousePress data to controls. Call within mousePressed();
  void detectPress(float x_, float y_){
    /*
    for(int i = 0; i < numControls; i++){
      controls[i].toggleSelected(x_,y_);
    }
    */
  }
  
  // Function to relay mouseDrag data to controls. Call within mouseDragged();
  void detectDrag(float x_, float y_){
    for(int i = 0; i < nc; i++){
      controls[i].dragControl(x_,y_);
    }
  }
  
  // Function to relay mouseRelease data to controls. Call within mouseReleased();
  void detectRelease(){
    for(int i = 0; i < nc; i++){
      controls[i].detectRelease();
    }
    outer.dragPause(false);
    inner.dragPause(false);
  }
}

class CenterCircle{
  float x, y, r, sw;
  color cPrimary, cSecondary;
  
  CenterCircle(float x_, float y_, float r_, float sw_, color c1_, color c2_){
    x = x_;
    y = y_;
    r = r_;
    sw = sw_;
    cPrimary = c1_;
    cSecondary = c2_;
  }
  
  void drawCenterCircle(){
    pushMatrix();
    translate(x,y);
    stroke(cPrimary);
    strokeWeight(sw);
    fill(0);
    ellipse(0,0,r*2,r*2);
    popMatrix(); 
  }
}

// The dotted circular line
class DotPath{
  float x, y, r;
  float dr;
  color dcolor;
  int numDots;
  float orientation, direction, rate;
  float angleBetween;
  
  DotPath(float x_, float y_, float r_, float dr_, color dc_, int nd_, float dir_){
    x = x_;
    y = y_;
    r = r_;
    dr = dr_;
    dcolor = dc_;
    numDots = nd_;
    orientation = 0;
    direction = dir_;
    rate = direction;
  }
  
  void drawDotPath(){
    angleBetween = 2 * PI / numDots;
    orientation += rate;
    for(int i = 1; i <= numDots; i++){
      float tempAngle = angleBetween * i - PI + orientation;
      if(tempAngle < -PI){
        tempAngle += 2*PI; 
      } else if(tempAngle > PI){
        tempAngle -= 2*PI; 
      }
      pushMatrix();
      translate(x,y);
      rotate(tempAngle);
      noStroke();
      fill(dcolor);
      ellipse(0, r, dr, dr);
      popMatrix();
    }
  }
  
  void dragPause(boolean b_){
    if(b_){
      rate = 0; 
    } else {
      rate = direction; 
    }
  }
  
  float getNumDots(){
    return numDots; 
  }
  
  float getOrientation(){
    return orientation; 
  }
  
  float getRadiusRatio(){
    return r; 
  }
  
  float getDirection(){
    return direction; 
  }
  
  float getAngleBetween(){
    return angleBetween; 
  }
}