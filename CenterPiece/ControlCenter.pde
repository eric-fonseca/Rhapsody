class ControlCenter{
  
  final int numControls = 3;
  final float centerCircleRatio = 0.5;
  final float outerRingRatio = 1.0;
  final float outerRingRotate = -0.0010;
  final float innerRingRatio = 0.5;
  final float innerRingRotate = 0.0015;
  final float outerControlRatio = 0.3;
  final float innerControlRatio = 0.2;
  
  CenterCircle centerCircle;
  DotPath outer, inner;
  Control[] controls = new Control[numControls];
  float x, y, r;  

  ControlCenter(float x_, float y_, float r_){
    x = x_;
    y = y_;
    r = r_;
    centerCircle = new CenterCircle(x,y,r*centerCircleRatio, 8, color(247, 255, 58), color(255,46,135));
    outer = new DotPath(x,y,r*outerRingRatio,5,color(255, 202), 30, outerRingRotate);
    inner = new DotPath(x,y,r*innerRingRatio,5,color(255, 202), 20, innerRingRotate);
    for(int i = 0; i < numControls; i++){
      float temp = 2 * PI / numControls;
      Control c = new Control(x,y,r,i * temp - PI,inner,outer,innerControlRatio,outerControlRatio,5,color(247, 255, 58),color(255,46,135));
      controls[i] = c;
    }
  }
  
  void drawAll(){
    boolean btemp = false;
    outer.drawDotPath(); 
    inner.drawDotPath();
    centerCircle.drawCenterCircle();
    splitControls();
    for(int i = 0; i < numControls; i++){
      controls[i].update();
      controls[i].drawControl();
    }
  }
  
  void splitControls(){
    for(int i = 0; i < numControls; i++){
      for(int u = i; u < numControls; u++){
        if(u == i){
          continue;
        }
        if(controls[i].getSelected() == false && controls[u].getSelected() == false){
          boolean a1B = false; 
          boolean a2B = false;
          Control c1 = controls[i];
          Control c2 = controls[u];
          float a1 = c1.getAngle() + PI;
          float a2 = c2.getAngle() + PI;
          if(Math.abs(Math.abs(a1) - Math.abs(a2)) < PI/6){
            if(a1 > a2){
              pushControls(a1,c1,PI/16);
              pushControls(a2,c2,-PI/16);
            } else {
              pushControls(a1,c1,-PI/16);
              pushControls(a2,c2,PI/16);
            }
          }
        }
      }
    }
  }
    
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
  
  void detectPress(float x_, float y_){
    for(int i = 0; i < numControls; i++){
      controls[i].toggleSelected(x_,y_);
    }
  }
  
  void detectDrag(float x_, float y_){
    for(int i = 0; i < numControls; i++){
      controls[i].dragControl(x_,y_);
    }
  }
  
  void detectRelease(){
    for(int i = 0; i < numControls; i++){
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

class Control{
  float cx, cy, cr;
  float x, y, r, a, sw;
  float tx, ty, tr;
  DotPath inner, outer;
  float icr, ocr;
  float rate;
  color cPrimary, cSecondary;
  boolean isRightSide;
  boolean selected = false;
  boolean isDragging = false;
  
  // parameters looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooool
  Control(float cx_, float cy_, float r_, float a_, DotPath inner_, DotPath outer_, float icr_, float ocr_, float sw_, color c1_, color c2_){
    cx = cx_;
    cy = cy_;
    x = cx_;
    y = cy_;
    r = 0;
    cr = r_;
    a = a_;
    sw = sw_;
    icr = icr_;
    ocr = ocr_;
    cPrimary = c1_;
    cSecondary = c2_;
    inner = inner_;
    outer = outer_;
    rate = inner.getDirection();
    tx = sin(a) * inner.getRadiusRatio() + cx;
    ty = cos(a) * outer.getRadiusRatio() + cy;
  }
  
  void update(){
    float tempAngle = a + rate;
    if(tempAngle < -PI){
      tempAngle += 2*PI; 
    } else if(tempAngle > PI){
      tempAngle -= 2*PI; 
    }
    
    a = tempAngle;
    if(!isDragging){
      if(selected){
        tr = cr * ocr;
        if(Math.abs(a) > PI/2){
          tx = cos(PI) * outer.getRadiusRatio() + cx;
          ty = sin(PI) * outer.getRadiusRatio() + cy;
        } else {
          tx = cos(0) * outer.getRadiusRatio() + cx;
          ty = sin(0) * outer.getRadiusRatio() + cy;
        }
        rate = 0;
        /*
        tx = cos(a) * outer.getRadiusRatio() + cx;
        ty = sin(a) * outer.getRadiusRatio() + cy;
        rate = outer.getDirection();
        */
      } else {
        tr = cr * icr;

        tx = cos(a) * inner.getRadiusRatio() + cx;
        ty = sin(a) * inner.getRadiusRatio() + cy;
        rate = inner.getDirection();
      }
    }
    
    r += (tr - r)/10;
    x += (tx - x)/10;
    y += (ty - y)/10; 
  }
  
  void drawControl(){
    pushMatrix();
    if(selected){
      if(Math.abs(a) > PI/2){
        stroke(cSecondary);
      } else {
        stroke(cPrimary);
      }
    } else {
      stroke(255);
    }
    strokeWeight(sw);
    fill(0);
    ellipse(x,y,r,r);
    popMatrix(); 
  }
  
  void toggleSelected(float x_, float y_){
    if(dist(x_,y_,x,y) < r/2+sw/2){
       if(selected){
         selected = false;
         //segueToInner();
       } else {
         selected = true;
       }
    }
  }
  
  void dragControl(float x_, float y_){
    if(dist(x_,y_,x,y) < r+sw/2){
      isDragging = true;
      rate = 0;
      tr = cr * ocr;
      tx = x_;
      ty = y_;
      outer.dragPause(isDragging);
      inner.dragPause(isDragging);
    }
  }
  
  void detectRelease(){
    isDragging = false;
    a = atan2(y - cy,x - cx);
    //segueToOuter();
  }
  
  void segueToInner(){
    getInnerAngle: 
    for(int i = 1; i <= inner.getNumDots(); i++){
      float tempInnerAngle = inner.getAngleBetween() * i  - PI + inner.getOrientation();
      if(tempInnerAngle < -PI){
        tempInnerAngle += 2*PI; 
      } else if(tempInnerAngle > PI){
        tempInnerAngle -= 2*PI; 
      }
    
      if(a - tempInnerAngle < inner.getAngleBetween()){
        a = tempInnerAngle;
        break getInnerAngle;
      }
    }
  }
  
  void segueToOuter(){
    getOuterAngle: 
    for(int i = 1; i <= outer.getNumDots(); i++){
      float tempOuterAngle = outer.getAngleBetween() * i  - PI + outer.getOrientation() + outer.getAngleBetween()/2;
      if(tempOuterAngle < -PI){
        tempOuterAngle += 2*PI; 
      } else if(tempOuterAngle > PI){
        tempOuterAngle -= 2*PI; 
      }

      if(a - tempOuterAngle < outer.getAngleBetween()){
        a = tempOuterAngle;
        break getOuterAngle;
      }
    }
  }
  
  boolean getSelected(){
   return selected; 
  }
  
  boolean getSideSelect(){
    return isRightSide;
  }
  
  float getAngle(){
    return a; 
  }
  
  void setAngle(float a_){
    a = a_;
  }
}
