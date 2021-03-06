// Dial knob for the user to change how effects are changing the audio track
class KnobControl extends Control{
  float setAngle, knobAngle;
  Boolean movable = false; // Use this var to state is knob is interact-able or drawn on sketch
  Boolean block = false;
  Boolean centerPressed = false;
  color cPrimary, cSecondary;
  PImage outerGlow = loadImage("knobGlow.png");
  PImage muted = loadImage("Volume-Off.png");
  PImage playing = loadImage("Volume-.png");
  String label;
  TrackControl parent;
  String zoneName;
  Zone zone;
  
  // Constant Ratios
  final float a = PI/8;
  final color unpressedbackgroundColor = #202020;
  final color pressedbackgroundColor = #404040;
  final color unselectedCenterButtonColor = #C8C8C8;
  final float hitboxSpread = 1.4;
  final float labelSpread = 1.1;
  final float centerCircle = 0.7;
  final float scanPadding = 1.1;
  final int unselectedAlpha = 95;
  final int gradientParts = 20;
  final float splitArcRatio = 0.04;
  
  // Animation variables
  float taa1 = 0;
  float taa2 = 0;
  float tar1, tar2, tar3;
  
  // Animation constants
  final float taa1Rate = PI/45; // Make taa1Rate always a third of taa2Rate
  final float taa2Rate = PI/15;
  final float tarFrames = 10;
  final float phase1Cutoff = 0.25;
  final float phase2Cutoff = 0.0005;
  final int numDragDots = 5;
  
  KnobControl(float x_, float y_, float r_, float sw_, float a_, float setAngle_, float initValue, color ccolor1_, color ccolor2_, TrackControl tc_, String l_, String zn_){
    super(x_, y_, r_, sw_, 3);
    setAngle = setAngle_; // SetAngle should only be either 0 or PI
    knobAngle = initValue;
    cPrimary = ccolor1_;
    cSecondary = ccolor2_;
    parent = tc_;
    label = l_;
    zoneName = zn_;
    Zone zone = new Zone(zoneName,round(x-r*hitboxSpread/2),round(y-r*hitboxSpread/2),round(r*hitboxSpread),round(r*hitboxSpread));
    SMT.add(zone);
  }
  
    void setNewPosition(float x_, float y_, float sa_){
      x = x_;
      y = y_;
      if(setAngle == 0 && sa_ == PI){
        resetKnobAngle();
      }
      if(setAngle == PI && sa_ == 0){
        resetKnobAngle();
      }
      setAngle = sa_; // SetAngle should only be either 0 or PI
      resizeZones();
    }
    
      void resetKnobAngle(){
        knobAngle += PI;
        if(knobAngle > PI){
          knobAngle -= 2*PI; 
        }
      }
    
    void setColorValues(color pri, color sec){
      cPrimary = pri;
      cSecondary = sec;
    }
    
    // Returns the value ratio of the current knob
    float getValue(){
      float value;
      if(setAngle == 0){
        if(knobAngle > -a*1.1 && knobAngle < a){
         return 1.0;
        }
        if(knobAngle > a*1.1){
         value = map(knobAngle, a, PI, 0, 0.5);
         return value;
        }
        if(knobAngle < -1.1*a){
         value = map(knobAngle, -PI, -a, 0.5, 1.0);
         return value;
        }
      } else {
       if(knobAngle > PI - a){
         return 1.0;
       }
       value = map(knobAngle, a - PI, PI - a, 0, 1.0);
       return value;
      }
      // Ideally never returns zero
      return 0;
    }
    
   void update(){
     super.update(); 
   }
    
   void resizeZones(){
    // Updating zone properties
    SMT.get(zoneName).setX(round(x - r*hitboxSpread/2));
    SMT.get(zoneName).setY(round(y - r*hitboxSpread/2));
    SMT.get(zoneName).setWidth(round(r*hitboxSpread));
    SMT.get(zoneName).setHeight(round(r*hitboxSpread));
   }
  
   // Built to be ran every frame
   void animate(){
     super.animate();
     if(animating){
       if(!phaseSwitch && !phases[0] && !phases[1] && !phases[2]){
         phaseSwitch = true;
         phases[0] = true; 
       }
       if(phases[0]){
         if(phaseSwitch){
           if(setAngle == PI){
             taa1 = 0;
             taa2 = 0;
           } else {
             taa1 = -PI;
             taa2 = -PI;
           }
           phaseSwitch = false; 
         } else { // phaseSwitch = false
           taa1 += taa1Rate;
           taa2 += taa2Rate;
           pushMatrix();
           translate(x,y);
           noFill();
           stroke(cPrimary);
           strokeWeight(sw);
           arc(0, 0, r, r, taa1, taa2);
           popMatrix(); 
         }
         
         if(setAngle == PI){
           if(taa1 > PI){
             phaseSwitch = true;
             phases[0] = false;
             phases[1] = true;
           }
         } else { // If setAngle == 0
           if(taa1 > 0){
             phaseSwitch = true;
             phases[0] = false;
             phases[1] = true;
           }
         }
       } else if(phases[1]){
         if(phaseSwitch){
           addEcho();
           echoes.get(0).start = true;
           phaseSwitch = false;
           tar1 = 0;
           tar2 = 0;
           taa1 = 0;
         } else {
           drawEchoes();
           
           tar1 += (r * centerCircle - tar1)/tarFrames;
           tar2 += (r - tar2)/tarFrames;
           if((r * centerCircle - tar1)/tarFrames < phase1Cutoff){
             phaseSwitch = true;
             phases[1] = false;
             phases[2] = true;
           }
           
           drawCenterComponents(tar1);
           drawArcComponents(tar2, true);
         }
       } else if(phases[2]){
         if(phaseSwitch){
           tar3 = 0;
           phaseSwitch = false;
         }
         
         tar3 += (r * hitboxSpread - tar3)/tarFrames*2;
         if((r * hitboxSpread - tar3)/tarFrames*2 < phase2Cutoff){
           animating = false;
           phaseSwitch = false;
           phases[2] = false;
         }
         
         drawBackgroundComponents(tar3);
         drawCenterComponents(tar1);
         drawArcComponents(tar2, true);
       }
     } else { // If animating = false
       drawControl(); 
     }
   }
   
     // Drawing the functional Knob
     void drawControl(){
       super.drawControl();
       drawBackgroundComponents(r * hitboxSpread);
       drawCenterComponents(r * centerCircle);
       drawArcComponents(r, true);
     }
     
       void drawBackgroundComponents(float r_){
         // Background draw
         pushMatrix();
         translate(x,y);
         noStroke();
         if(pressed){
           fill(pressedbackgroundColor);
         } else {
           fill(unpressedbackgroundColor);
         }
         ellipse(0,0,r_,r_);
         popMatrix();
       }
     
       void drawCenterComponents(float r_){
         pushMatrix();
         translate(x,y);
         noStroke();
         if(selection){
           fill(cPrimary);
           ellipse(0,0,r_,r_);
           //image(outerGlow, -r_/2, -r_/2, r_, r_);
           if(parent.getDirection() == "right"){
             rotate(-PI/2);
           } else {
             rotate(PI/2);
           }
           image(playing, -r_/4, -r_/4, r_/2, r_/2);
         } else {
           fill(unselectedCenterButtonColor);
           ellipse(0,0,r_,r_);
           if(parent.getDirection() == "right"){
             rotate(-PI/2);
           } else {
             rotate(PI/2);
           }
           image(muted, -r_/4, -r_/4, r_/2, r_/2);
         }
         popMatrix();
       }
     
       void drawArcComponents(float r_, boolean isMouseActive){
         // Dull Arc
         pushMatrix();
         translate(x,y);
         noFill();
         stroke(unselectedCenterButtonColor);
         strokeWeight(sw);
         if(setAngle == 0){
           if(knobAngle > 0){
             arc(0, 0, r_, r_, knobAngle, PI);
             arc(0, 0, r_, r_, -PI, -a);
           } else {
             arc(0, 0, r_, r_, knobAngle, -a);
           }
         } else {
           arc(0, 0, r_, r_, knobAngle, PI - a);
         }
         popMatrix();
         
         // First Highlight Arc
         pushMatrix();
         translate(x,y);
         noFill();
         if(selection){
           stroke(cPrimary);
         } else {
           stroke(cPrimary, 95);
         }
         strokeWeight(sw);
         if(setAngle == 0){
           arc(0, 0, r_, r_, a, knobAngle);
         } else {
           arc(0, 0, r_, r_, a - PI, knobAngle);
         }
         popMatrix();
        
         // Second hightlight arc, sometimes needed due to processing's rotation handling
         if(setAngle == 0){
           if(knobAngle < a){
           pushMatrix();
           translate(x,y);
           rotate(setAngle);
           noFill();
           if(selection){
             stroke(cPrimary);
           } else {
             stroke(cPrimary, 95);
           }
           strokeWeight(sw);
           arc(0, 0, r_, r_, a, PI);
           arc(0, 0, r_, r_, -PI + splitArcRatio, knobAngle);
           popMatrix();
           }
         } 
         
         // Small indication circle
         pushMatrix();
         translate(x,y);
         rotate(knobAngle - PI/2);
         noStroke();
         fill(255);
         ellipse(0,r_/2,sw*4,sw*4);
         popMatrix();
         
         // Label
         pushMatrix();
         textAlign(CENTER);
         if(parent.getDirection() == "right"){
           translate(x + r * labelSpread,y);
           rotate(-PI/2);
         } else if(parent.getDirection() == "left"){
           translate(x - r * labelSpread,y);
           rotate(PI/2);
         }
         
         fill(255);
         textSize(height/35);
         text(label,0, 0);
         popMatrix();
       }
     
   
   void addEcho(){
     color temp;
     if(Math.abs(a) > PI/2){
       temp = cSecondary;
     } else {
       temp = cPrimary;
     }
     Echo ce = new Echo(x,y,r,5,10,sw,temp);
     echoes.add(ce);
   }
   
   // This class doens't use the Control class detectPress() method
   void passPress(float x_, float y_){
     if(!parent.selection){
       return; 
     }
     float temp = dist(x_, y_, x, y);
     
     if(temp < (r/2 * centerCircle)){
       pressed = true;
       centerPressed = true;
       
       // Toggling selection value
       if(selection){
        selection = false; 
       } else {
        selection = true; 
       }
     } else if(temp < (r/2 * hitboxSpread)){
       pressed = true;
     }
     audioControl.handlePress();
   }
   
   // This class doens't use the Control class detectDrag() method
   void passDrag(float x_, float y_){
     if(!parent.selection){
       return; 
     }
     
     float tDist = dist(x_, y_, x, y);
     if(tDist < r/2 * centerCircle){
       return;
     }
     
     float tAngle = atan2(y_ - y, x_ - x);
     if(pressed){
      
      if(setAngle == 0){
        if(tAngle < a && tAngle > -a){
          if(tAngle + a >= a){
            tAngle = a;
            block = true;
          }
          if(tAngle - a <= -a){
            tAngle = -a;
            block = true;
          }
         }
       else{
         moveToMouseAngle(tAngle);
       }
      } else { // setAngle = PI
        if(tAngle > PI - a || tAngle < a - PI){
          if(tAngle + a >= 0){
            tAngle = PI - a;
            block = true;
          }
          if(tAngle - a <= 0){
            tAngle = a - PI;
           block = true; 
          }
        } else {
          moveToMouseAngle(tAngle);
        }
      }
    }
    drawDragDots(tDist, tAngle);
    audioControl.handleDrag();
  }
   
     void drawDragDots(float t_, float a_){
       float dPadding = (t_ - r/2 * hitboxSpread)/numDragDots;
       for(int i = 0; i < numDragDots; i++){
         pushMatrix();
         translate(cos(a_) * (r/2 * hitboxSpread + dPadding * (i + 1)),sin(a_) * (r/2 * hitboxSpread + dPadding * (i + 1)));
         noStroke();
         fill(#FFFFFF, 100);
         float tCircleRadius = 0;
         if(i != numDragDots - 1){
           tCircleRadius = sw*2;
         } else {
           tCircleRadius = sw*4;
         }
         ellipse(r/2 + 20,r/2 + 20,tCircleRadius,tCircleRadius);
         popMatrix();
       }
     }
   
     // support function
     void moveToMouseAngle(float temp){
       if(!(knobAngle > temp && block)){
         knobAngle = temp;
         movable = true;
         block = false;
       }
       if(!(knobAngle < temp && block)){
         knobAngle = temp;
         movable = true;
         block = false;
       }
     }
     
   // This class doens't use the Control class detectRelease() method
   void passRelease(){
     movable = false;
     pressed = false;
     centerPressed = false;
   }
}
