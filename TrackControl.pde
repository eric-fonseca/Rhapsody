// track selection UI component
class TrackControl extends Control{
  float a;
  float cx, cy, cr;
  float tsx, tsy, tsr;
  float rate, increasedRate, heightSpacing;
  color cPrimary, cSecondary;
  boolean isDragging = false;
  PImage icon;
  float iconSize = 48;
  String[] zoneNames;
  Zone zone;
  
  // Object References
  DotPathControl inner, outer;
  CenterControl cc;
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final int numberOfKnobs = 3;
  final float selectedControlRatio = 0.3; // Relative radius ratio of Controls when they are selected
  final float unselectedControlRatio = 0.2; // Relative radius ratio of Controls when they are selected
  final float widthSpacingRatio = 0.20; // Spacing of of far the knobs are drawn from the edges of the screen
  final float knobRadius = 125;
  final float dynamicAnimationRate = 10; // Speed of how quickly this class snaps to new given positions
  final float maxIconSize = 96;
  final float minIconSize = 48;
  
  // Animation constants
  final float frameLength = 30;
  final float animationCutoff = 1;
  final float phase0_updateCutoff = 5;
  final float echoesOpacityRate = 10;
  final float echoesRadiusRate = 5;
  
  // Objects to populate within class
  KnobControl[] knobs = new KnobControl[numberOfKnobs];
  DoubleBarControl doubleBar;
  
  TrackControl(float cx_, float cy_, float r_, float sw_, float a_, float irr_, DotPathControl inner_, DotPathControl outer_, CenterControl cc_, color c1_, color c2_, String[] zn_){
    super(cx_, cy_, 0, sw_, 3);
    a = a_; // angle away from center point of ControlCenter
    rate = inner_.direction; // rate of rotation while in the inner dot path
    increasedRate = irr_;
    heightSpacing = height/(numberOfKnobs + 1); // building variable
    
    inner = inner_; // Reference to dot path
    outer = outer_; // Reference to dot path
    cc = cc_; // Reference to center Control
    
    cPrimary = c1_; // Setting colors
    cSecondary = c2_;
    
    cx = cx_; // reference to x-value of center point of ControlCenter
    cy = cy_; // reference to y-value of center point of ControlCenter
    cr = r_; // reference to the distance of this object from the center point of ControlCenter
    
    tsx = sin(a) * inner_.r + cx; // the x-value where the tsrack Control move towards over time
    tsy = cos(a) * outer_.r + cy; // the y-value where the tsrack Control move towards over time
    tsr = 0; // For changes in radius over time
    
    zoneNames = zn_;
    
    // Creating controls
    for (int i = 0; i < numberOfKnobs; i++){
      knobs[i] = new KnobControl(0, 0, knobRadius, 5, PI/8, PI, 0, color(247, 255, 58), color(255,46,135),this,"Test",zoneNames[i+1]);
    }
    
    doubleBar = new DoubleBarControl(-50, -50, sw*2, color(247, 255, 58), height/3,this,"Frequency Filter",zoneNames[4]);
    
    zone = new Zone(zoneNames[0],round(x-r/2),round(y-r/2),round(r),round(r));
    SMT.add(zone);
  }
  
    void setIcon(PImage p_){
      iconSize = 48;
      icon = p_;
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
    super.update();
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
        float widthSpacing = width * widthSpacingRatio;
        if(Math.abs(a) > PI/2){ // If selection is left side
          tsx = cos(PI) * outer.r + cx;
          tsy = sin(PI) * outer.r + cy;
          // Changes the knobs towards the left side
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(widthSpacing, heightSpacing * (i + 1), PI);
            knobs[i].setColorValues(cSecondary, cPrimary);
            knobs[i].update();
            if(doubleBar.orientRight){
              doubleBar.flipValues(); 
            }
            doubleBar.setNewPosition(widthSpacing/3, height/2);
            doubleBar.setColorValues(cSecondary);
            doubleBar.update();
          }
        } else { // If selection is right side
          tsx = cos(0) * outer.r + cx;
          tsy = sin(0) * outer.r + cy;
          // Changes the knobs towards the right side
          for(int i = 0; i < numberOfKnobs; i++){
            knobs[i].setNewPosition(width - widthSpacing, heightSpacing * (i + 1), 0);
            knobs[i].setColorValues(cPrimary, cSecondary);
            knobs[i].update();
            if(!doubleBar.orientRight){
              doubleBar.flipValues(); 
            }
            doubleBar.setNewPosition(width - widthSpacing/3, height/2);
            doubleBar.setColorValues(cPrimary);
            doubleBar.update();
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
    
    if(selection || isDragging){
      iconSize += (maxIconSize - iconSize)/dynamicAnimationRate;
    } else {
      iconSize += (minIconSize - iconSize)/dynamicAnimationRate;
    }
    
    // Rate of change is higher when objects are farther away from objective location
    r += (tsr - r)/dynamicAnimationRate;
    x += (tsx - x)/dynamicAnimationRate;
    y += (tsy - y)/dynamicAnimationRate; 
    
    // Updating zone properties
    SMT.get(zoneNames[0]).setX(round(x - r/2));
    SMT.get(zoneNames[0]).setY(round(y - r/2));
    SMT.get(zoneNames[0]).setWidth(round(r));
    SMT.get(zoneNames[0]).setHeight(round(r));
  }
  
  void animate(){
    super.animate();
    if(animating){
      if(!phaseSwitch && !phases[0] && !phases[1] && !phases[2]){
        phaseSwitch = true;
        phases[0] = true; 
      } else if(phases[0]){
        tsr += (r * unselectedControlRatio - tsr) / frameLength;
        drawControl(tsr);
        
        if(tsr - r < animationCutoff){
          phases[0] = false;
          phases[1] = true; 
        }
      } else if(phases[1]){
        drawControl(tsr);
        if(tsx - x < phase0_updateCutoff && tsy - y < phase0_updateCutoff){
          phases[1] = false;
          phases[2] = true;
          phaseSwitch = true;
        }
      } else if(phases[2]){
        if(phaseSwitch){
          Echo ce = new Echo(x,y,r,echoesRadiusRate,echoesOpacityRate,sw,cPrimary);
          ce.start = true;
          echoes.add(ce);
          animating = false;
          phaseSwitch = false; 
        }
      }
    } else {
      drawControl(r); 
    }
  }
  
  void drawControl(float r_){
    super.drawControl();
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
    ellipse(x,y,r_,r_);
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    rotate(a);
    image(icon,-iconSize/2,-iconSize/2,iconSize,iconSize);
    popMatrix();
  }
  
  // Drawing classes assoicated within this class
  void drawInnerControls(){
   // pushing and popping occurs inside the ControlKnob class
   if(selection && !isDragging){
      for(int i = 0; i < numberOfKnobs; i++){
        if(knobs[i].x != 0 && knobs[i].y != 0){
          knobs[i].animate();
        }
      }
      doubleBar.animate();
    } else { // Doesn't draw the knobs
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].animating = true;
      }
      doubleBar.animating = true;
    }
  }
  
  // Method to add echo object to this class, in the MainInterface
  void addEcho(){
    color temp;
    if(Math.abs(a) > PI/2){
      temp = cSecondary;
    } else {
      temp = cPrimary;
    }
    Echo ce = new Echo(x,y,tsr,echoesRadiusRate,echoesOpacityRate,sw,temp);
    echoes.add(ce);
  }

  // This class doens't use the Control class detectPress() method
  void passPress(float x_, float y_){
    if(dist(x_,y_,x,y) < r){
      pressed = true;
    }
    /*
    if(selection){
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].passPress(x_, y_);
      }
      doubleBar.detectPress(x_,y_);
    }
    */
  }
  
  // This class doens't use the Control class detectDrag() method
  void passDrag(float x_, float y_){
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
          SMT.get(knobs[i].zoneName).setTouchable(true);
          SMT.get(knobs[i].zoneName).setPickable(true);
          knobs[i].animating = true;
        }
        SMT.get(doubleBar.zoneName).setTouchable(true);
        SMT.get(doubleBar.zoneName).setPickable(true);
        
      } else {
        selection = false;
        for(int i = 0; i < numberOfKnobs; i++){
          SMT.get(knobs[i].zoneName).setTouchable(false);
          SMT.get(knobs[i].zoneName).setPickable(false);
        }
        SMT.get(doubleBar.zoneName).setTouchable(false);
        SMT.get(doubleBar.zoneName).setPickable(false);
      }
    }
    /*
    if(selection){
      for(int i = 0; i < numberOfKnobs; i++){
        knobs[i].passDrag(x_, y_);
      }
      doubleBar.detectDrag(x_,y_);
    }
    */
  }
  
  // This class doens't use the Control class detectRelease() method
  void passRelease(){
    isDragging = false;
    pressed = false;
    a = atan2(y - cy,x - cx);
    
    /*
    for(int i = 0; i < numberOfKnobs; i++){
      knobs[i].passRelease();
    }
    doubleBar.detectRelease();
    */
    
    for(int i = 0; i < echoes.size(); i++){
      echoes.get(i).start = true;
    }
  }
}
