// tsrack selection UI component
class TrackControl extends Control{
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float selectedControlRatio = 0.3; // Relative radius ratio of Controls when they are selected
  final float unselectedControlRatio = 0.2; // Relative radius ratio of Controls when they are selected
  final int numberOfKnobs = 3;
  final float widthSpacingRatio = 0.10; // Spacing of of far the knobs are drawn from the edges of the screen
  final float knobRadius = 150;
  final float animationRate = 10; // Speed of how quickly this class snaps to new given positions
  
  float cx, cy, cr;
  float a, sw;
  float tsx, tsy, tsr;
  float rate, increasedRate, heightSpacing;
  color cPrimary, cSecondary;
  boolean isDragging = false;
  DotPathControl inner, outer;
  CenterControl cc;
  ArrayList<Echo> echoes;
  KnobControl[] knobs = new KnobControl[numberOfKnobs];
  
  TrackControl(float cx_, float cy_, float r_, float a_, DotPathControl inner_, DotPathControl outer_, CenterControl cc_, float sw_, color c1_, color c2_, float irr_){
    super(cx_, cy_, 0, 0);
    cx = cx_; // reference to x-value of center point of ControlCenter
    cy = cy_; // reference to y-value of center point of ControlCenter
    cr = r_; // reference to the distance of this object from the center point of ControlCenter
    
    a = a_; // angle away from center point of ControlCenter
    sw = sw_; // stsroke width
    
    tsx = sin(a) * inner_.r + cx; // the x-value where the tsrack Control move towards over time
    tsy = cos(a) * outer_.r + cy; // the y-value where the tsrack Control move towards over time
    tsr = 0; // For changes in radius over time
    
    rate = inner_.direction; // rate of rotation while in the inner dot path
    increasedRate = irr_;
    heightSpacing = height/(numberOfKnobs + 1); // building variable
    
    cPrimary = c1_; // Setting colors
    cSecondary = c2_;

    inner = inner_; // Reference to dot path
    outer = outer_; // Reference to dot path
    cc = cc_; // Reference to center Control
    echoes = new ArrayList<Echo>(); // Echoes are for user feedback when an action is denied
    
    // Creating knobs
    for (int i = 0; i < numberOfKnobs; i++){
      knobs[i] = new KnobControl(0, 0, knobRadius, PI/8, 5, color(247, 255, 58), color(255,46,135), PI, 0);
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
      if(cc.selection){
        rate = inner.direction * increasedRate;
      } else {
        rate = inner.direction;
      }
      
      // Code to slowly rotate the tsrack Control while on the inner dot path
      if(!selection){
        float tempAngle = a + rate;
        if(tempAngle < -PI){
          tempAngle += 2*PI; 
        } else if(tempAngle > PI){
          tempAngle -= 2*PI; 
        }
        a = tempAngle;
      }
      
      if(selection){
        tsr = cr * selectedControlRatio;
        float widthSpacing;
        if(Math.abs(a) > PI/2){ // If selection is left side
          widthSpacing = width * widthSpacingRatio;
          tsx = cos(PI) * outer.r + cx;
          tsy = sin(PI) * outer.r + cy;
          // Changes the knobs towards the left side
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(widthSpacing, heightSpacing * (i + 1), PI);
            knobs[i].setColorValues(cSecondary, cPrimary);
          }
        } else { // If selection is right side
          widthSpacing = width - width * widthSpacingRatio;
          tsx = cos(0) * outer.r + cx;
          tsy = sin(0) * outer.r + cy;
          // Changes the knobs towards the right side
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(widthSpacing, heightSpacing * (i + 1), 0);
            knobs[i].setColorValues(cPrimary, cSecondary);
          }
        }
        rate = 0;
      } else { // If not selected
        tsr = cr * unselectedControlRatio;
        tsx = cos(a) * inner.r + cx;
        tsy = sin(a) * inner.r + cy;
        rate = inner.direction;
      }
    } else { // If is currently being dragged
      a = atan2(y - cy,x - cx);
    }
    
    // Rate of change is higher when objects are farther away from objective location
    r += (tsr - r)/animationRate;
    x += (tsx - x)/animationRate;
    y += (tsy - y)/animationRate; 
  }
  
  void drawTrackControl(){
    pushMatrix();
    if(selection){
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
  
    void animateIntro(){

    }
  
  void drawControlKnobs(){
   // pushing and popping occurs inside the ControlKnob class
   if(selection && !isDragging){
      for(int i = 0; i < numberOfKnobs; i++){
        if(knobs[i].x != 0 && knobs[i].y != 0){
          knobs[i].active = true;
          knobs[i].animate();
        }
      }
    } else { // Doesn't draw the knobs
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].active = false;
        knobs[i].animating = true;
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

  void addEcho(){// Only one echo per Control for the moment
    if(echoes.size() > 0){
      return; 
    }
    
    color temp;
    if(Math.abs(a) > PI/2){
      temp = cSecondary;
    } else {
      temp = cPrimary;
    }
    Echo ce = new Echo(x,y,tsr,sw,temp);
    echoes.add(ce);
  }
  
  // Mouse Event Functions
  void passMousePress(float x_, float y_){
    if(dist(x_,y_,x,y) < r){
      pressed = true;
    }
    
    if(selection){
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].detectPress(x_, y_);
      }
    }
  }
  
  void passMouseDrag(float x_, float y_){
    if(pressed){
      isDragging = true;
      rate = 0;
      tsr = cr * selectedControlRatio;
      tsx = x_;
      tsy = y_;
      outer.dragPause(isDragging);
      inner.dragPause(isDragging);
      if(dist(x,y,cx,cy) > cr){
        selection = true; 
        for(int i = 0; i < numberOfKnobs; i++){
          knobs[i].animating = true;
        }
      } else {
        selection = false; 
      }
    }
    
    if(selection){
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].detectDrag(x_, y_);
      }
    }
  }
  
  void passMouseRelease(){
    isDragging = false;
    pressed = false;
    a = atan2(y - cy,x - cx);
    
    for(int i = 0; i < numberOfKnobs; i++){
      knobs[i].detectRelease();
    }
    
    for(int i = 0; i < echoes.size(); i++){
      echoes.get(i).start = true;
    }
  }
}
