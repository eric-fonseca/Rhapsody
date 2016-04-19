// Track selection UI component
class TrackControl{
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float increasedRotateRatio = 10; // The increased speed of rotation when center control is selected
  final float selectedControlRatio = 0.3; // Relative radius ratio of controls when they are selected
  final float unselectedControlRatio = 0.2; // Relative radius ratio of controls when they are selected
  final int numberOfKnobs = 3;
  final float widthSpacingRatio = 0.10; // Spacing of of far the knobs are drawn from the edges of the screen
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
  CenterControl cc;
  ArrayList<Echo> echoes;
  ControlKnob[] knobs = new ControlKnob[numberOfKnobs];
  float heightSpacing;
  
  TrackControl(float cx_, float cy_, float r_, float a_, DotPath inner_, DotPath outer_, CenterControl cc_, float sw_, color c1_, color c2_){
    cx = cx_; // reference to x-value of center point of ControlCenter
    cy = cy_; // reference to y-value of center point of ControlCenter
    cr = r_; // reference to the distance of this object from the center point of ControlCenter
    x = cx_; // current drawn x-value
    y = cy_; // current drawn y-value
    r = 0; // current radius size
    a = a_; // angle away from center point of ControlCenter
    sw = sw_; // stroke width
    tx = sin(a) * inner_.r + cx; // the x-value where the track control move towards over time
    ty = cos(a) * outer_.r + cy; // the y-value where the track control move towards over time
    tr = 0; // For changes in radius over time
    rate = inner_.direction; // rate of rotation while in the inner dot path
    cPrimary = c1_;
    cSecondary = c2_;
    inner = inner_; // Reference to dot path
    outer = outer_; // Reference to dot path
    cc = cc_; // Reference to center control
    echoes = new ArrayList<Echo>(); // Echoes are for user feedback when an action is denied
    heightSpacing = height/(numberOfKnobs + 1); // building variable

    // Creating knobs
    for (int i = 0; i < numberOfKnobs; i++){
      knobs[i] = new ControlKnob(0, 0, knobRadius, PI/8, 5, color(247, 255, 58), color(255,46,135), PI, 0);
    }
  }
  
    String getDirection(){
      if(Math.abs(a) > PI/2){
        return "left";
      } else {
        return "right"; 
      }
    }
  
  // Built to be ran every frame
  void update(){
    if(!isDragging){
      if(cc.selected){
        rate = inner.direction * increasedRotateRatio;
      } else {
        rate = inner.direction;
      }
      // Code to slowly rotate the track control while on the inner dot path
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
        if(Math.abs(a) > PI/2){ // If selection is left side
          widthSpacing = width * widthSpacingRatio;
          tx = cos(PI) * outer.r + cx;
          ty = sin(PI) * outer.r + cy;
          // Changes the knobs towards the left side
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(widthSpacing, heightSpacing * (i + 1), PI);
          }
        } else { // If selection is right side
          widthSpacing = width - width * widthSpacingRatio;
          tx = cos(0) * outer.r + cx;
          ty = sin(0) * outer.r + cy;
          // Changes the knobs towards the right side
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(widthSpacing, heightSpacing * (i + 1), PI);
          }
        }
        rate = 0;
      } else { // If not selected
        tr = cr * unselectedControlRatio;
        tx = cos(a) * inner.r + cx;
        ty = sin(a) * inner.r + cy;
        rate = inner.direction;
      }
    } else { // If is currently being dragged
      a = atan2(y - cy,x - cx);
    }
    
    // Rate of change is higher when objects are farther away from objective location
    r += (tr - r)/animationRate;
    x += (tx - x)/animationRate;
    y += (ty - y)/animationRate; 
  }
  
  void drawTrackControl(){
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
  
  void drawControlKnobs(){
   // pushing and popping occurs inside the ControlKnob class
   if(selected && !isDragging){
      for(int i = 0; i < numberOfKnobs; i++){
        if(knobs[i].x != 0 && knobs[i].y != 0){
          knobs[i].active = true;
          knobs[i].drawKnob();
        }
      }
    } else { // Doesn't draw the knobs
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].active = false;
      }
    } 
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

  void addEcho(){// Only one echo per control for the moment
    if(echoes.size() > 0){
      return; 
    }
    
    color temp;
    if(Math.abs(a) > PI/2){
      temp = cSecondary;
    } else {
      temp = cPrimary;
    }
    Echo ce = new Echo(x,y,r,sw,temp);
    echoes.add(ce);
  }
  
  // Mouse Event Functions
  void passMousePress(float x_, float y_){
    if(selected){
      for(int i = 0; i < numberOfKnobs; i++){
          knobs[i].switchSelection(x_, y_);
      }
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
    
    if(selected){
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].isMouseOnKnob(x_, y_);
      }
    }
  }
  
  void passMouseRelease(){
    isDragging = false;
    a = atan2(y - cy,x - cx);
    
    for(int i = 0; i < numberOfKnobs; i++){
      knobs[i].movable = false;
    }
    
    for(int i = 0; i < echoes.size(); i++){
      echoes.get(i).start = true;
    }
  }
}
