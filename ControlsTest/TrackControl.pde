class TrackControl{
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float selectedControlRatio = 0.3; // Relative radius ratio of controls when they are selected
  final float unselectedControlRatio = 0.2; // Relative radius ratio of controls when they are selected
  final int numberOfKnobs = 3; // 
  final float widthSpacingRatio = 0.10;
  final float knobRadius = 100;
  final float animationRate = 10; // Speed of how quickly this class snaps to new given positions
  
  float cx, cy, cr;
  float x, y, r, a, sw;
  float tx, ty, tr;
  float rate;
  color cPrimary, cSecondary;
  boolean selected = false;
  boolean isDragging = false;
  DotPath inner, outer;
  ArrayList<ControlEcho> echoes;
  ControlKnob[] knobs = new ControlKnob[numberOfKnobs];
  float heightSpacing;
  
  // parameters looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooool
  TrackControl(float cx_, float cy_, float r_, float a_, DotPath inner_, DotPath outer_, float sw_, color c1_, color c2_){
    cx = cx_;
    cy = cy_;
    cr = r_;
    x = cx_;
    y = cy_;
    r = 0;
    a = a_;
    sw = sw_;
    tx = sin(a) * inner_.getRadiusRatio() + cx;
    ty = cos(a) * outer_.getRadiusRatio() + cy;
    tr = 0;
    rate = inner_.getDirection();
    cPrimary = c1_;
    cSecondary = c2_;
    inner = inner_;
    outer = outer_;
    echoes = new ArrayList<ControlEcho>();
    heightSpacing = height/(numberOfKnobs + 1);

    for (int i = 0; i < numberOfKnobs; i++){
      knobs[i] = new ControlKnob(0, 0, knobRadius, PI/8, 5, color(247, 255, 58), color(255,46,135), PI, 0);
    }
  }
  
    float getAngle(){
      return a; 
    }
    
    void setAngle(float a_){
      a = a_;
    }
  
    boolean getSelected(){
     return selected; 
    }
    
    void setSelected(boolean b_){
      selected = b_;
    }
    
    String getDirection(){
      if(Math.abs(a) > PI/2){
        return "left";
      } else {
        return "right"; 
      }
    }
  
  // There's a lot of repeating for-loops, but for the sake of the least amount of if-statement checks, this runs the most efficiently- albeit looks ugly on code.
  void update(){
    if(!isDragging){
      float tempAngle = a + rate;
      if(tempAngle < -PI){
        tempAngle += 2*PI; 
      } else if(tempAngle > PI){
        tempAngle -= 2*PI; 
      }
      a = tempAngle;
      
      if(selected){
        tr = cr * selectedControlRatio;
        float widthSpacing;
        if(Math.abs(a) > PI/2){
          widthSpacing = width * widthSpacingRatio;
          tx = cos(PI) * outer.getRadiusRatio() + cx;
          ty = sin(PI) * outer.getRadiusRatio() + cy;
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(widthSpacing, heightSpacing * (i + 1), PI, 0);
          }
        } else {
          widthSpacing = width - width * widthSpacingRatio;
          tx = cos(0) * outer.getRadiusRatio() + cx;
          ty = sin(0) * outer.getRadiusRatio() + cy;
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(widthSpacing, heightSpacing * (i + 1), PI, 0);
          }
        }
        rate = 0;
      } else {
        tr = cr * unselectedControlRatio;
        tx = cos(a) * inner.getRadiusRatio() + cx;
        ty = sin(a) * inner.getRadiusRatio() + cy;
        rate = inner.getDirection();
      }
    } else {
      a = atan2(y - cy,x - cx);
    }
    
    r += (tr - r)/animationRate;
    x += (tx - x)/animationRate;
    y += (ty - y)/animationRate; 
  }
  
  void drawTrackControl(){
    drawEchoes();
    
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
    
    if(selected){
      for(int i = 0; i < numberOfKnobs; i++){
        if(knobs[i].getXPosition() != 0 && knobs[i].getYPosition() != 0){
          knobs[i].setActive(true);
          knobs[i].drawKnob();
        }
      }
    } else {
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].setActive(false);
      }
    }
  }
  
  // Mouse Event Functions
  void passMousePress(float x_, float y_){
    for(int i = 0; i < numberOfKnobs; i++){
      knobs[i].switchSelection(x_, y_);
    }
  }
  
  void passMouseDrag(float x_, float y_){
    if(dist(x_,y_,x,y) < r+sw/2 || isDragging){
      isDragging = true;
      rate = 0;
      tr = cr * selectedControlRatio;
      tx = x_;
      ty = y_;
      outer.dragPause(isDragging);
      inner.dragPause(isDragging);
      if(dist(x,y,cx,cy) > cr){
        selected = true; 
      } else {
        selected = false; 
      }
    }
    
    for(int i = 0; i < numberOfKnobs; i++){
      knobs[i].isMouseOnKnob(x_, y_);
    }
  }
  
  void passMouseRelease(){
    isDragging = false;
    a = atan2(y - cy,x - cx);
    
    for(int i = 0; i < numberOfKnobs; i++){
      knobs[i].movable = false;
    }
    
    for(int i = 0; i < echoes.size(); i++){
      echoes.get(i).setStart();
    }
  }
  
  void addEcho(){
    // Only one echo per control for the moment
    if(echoes.size() > 0){
      return; 
    }
    
    color temp;
    if(Math.abs(a) > PI/2){
      temp = cSecondary;
    } else {
      temp = cPrimary;
    }
    ControlEcho ce = new ControlEcho(x,y,r,sw,temp);
    echoes.add(ce);
  }
  
  void drawEchoes(){
    for(int i = echoes.size() - 1; i >= 0; i--){
      if(echoes.get(i).getOpacity() > 0){
        echoes.get(i).update();
      } else {
        echoes.remove(i); 
      }
    } 
  }
}

class ControlEcho{
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float opacityDecay = 10; // How quickly the echo's color alpha value decays each frame
  final float radiusRate = 10; // How quickly the radius of the echo increases each frame
  
  float x, y, r, o, sw;
  color primary;
  boolean start = false;

  ControlEcho(float x_, float y_, float r_, float sw_, color primary_){
    x = x_;
    y = y_;
    o = 255;
    sw = sw_;
    primary = primary_;
  }
  
    void setStart(){
      start = true;
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
