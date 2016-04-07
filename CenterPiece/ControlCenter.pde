class ControlCenter{
  float x, y, r;
  
  CenterCircle centerCircle;
  DotPath outer, inner;
  Control c1, c2, c3;
  
  final float centerCircleRatio = 0.5;
  final float outerRingRatio = 1.0;
  final float outerRingRotate = -0.0010;
  final float innerRingRatio = 0.7;
  final float innerRingRotate = 0.0015;
  final float outerControlRatio = 0.3;
  final float innerControlRatio = 0.2;

  ControlCenter(float x_, float y_, float r_){
    x = x_;
    y = y_;
    r = r_;
    centerCircle = new CenterCircle(x,y,r*centerCircleRatio, 8, color(247, 255, 58), color(255,46,135));
    outer = new DotPath(x,y,r*outerRingRatio,5,color(255, 202), 30, outerRingRotate);
    inner = new DotPath(x,y,r*innerRingRatio,5,color(255, 202), 20, innerRingRotate);
    c1 = new Control(x,y,r,0,inner,outer,innerControlRatio,outerControlRatio,5,color(247, 255, 58),color(255,46,135));
    //c2 = new Control(x,y,r,-2 * PI / 3,inner,outer,innerControlRatio,outerControlRatio,5,color(247, 255, 58),color(255,46,135));
    //c3 = new Control(x,y,r,2 * PI / 3,inner,outer,innerControlRatio,outerControlRatio,5,color(247, 255, 58),color(255,46,135));
  } 
  
  void drawAll(){
    centerCircle.drawCenterCircle();
    outer.drawDotPath(); 
    inner.drawDotPath();
    c1.update();
    //c2.update();
    //c3.update();
    c1.drawControl();
    //c2.drawControl();
    //c3.drawControl();
  }
  
  void detectPress(float x_, float y_){
    c1.toggleSelected(x_,y_);
    //c2.toggleSelected(x_,y_);
    //c3.toggleSelected(x_,y_);
  }
  
  void detectDrag(float x_, float y_){
    c1.dragControl(x_,y_);
    //c2.dragControl(x_,y_);
    //c3.dragControl(x_,y_);
  }
  
  void detectRelease(){
    c1.detectRelease();
    //c2.detectRelease();
    //c3.detectRelease();
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
        tx = cos(a) * outer.getRadiusRatio() + cx;
        ty = sin(a) * outer.getRadiusRatio() + cy;
        rate = outer.getDirection();
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
    if(dist(x_,y_,x,y) < r+sw/2){
       if(selected){
         selected = false;
         //segueToInner();
       } else {
         selected = true;
         //segueToOuter();
       }
    } else {
      selected = false; 
      //segueToInner();
    }
  }
  
  void dragControl(float x_, float y_){
    isDragging = true;
    selected = true;
    rate = 0;
    tr = cr * ocr;
    tx = x_;
    ty = y_;
    outer.dragPause(isDragging);
    inner.dragPause(isDragging);
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
}
