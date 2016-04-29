// Dial knob for the user to change how effects are changing the audio track
class KnobControl extends Control{
  float a, sw;
  float setAngle, knobAngle;
  color primary, secondary;
  Boolean active = false; // Use this var to state is knob is interact-able or drawn on sketch
  Boolean movable = false;
  Boolean block = false;
  PImage outerGlow = loadImage("knobGlow.png");
  ArrayList<Echo> echoes;
  
  // Animation variables
  float taa1 = 0;
  float taa2 = 0;
  float tar1, tar2, tar3;
  
  // Constant Ratios
  final color unpressedbackgroundColor = #202020;
  final color pressedbackgroundColor = #404040;
  final color unselectedCenterButtonColor = #C8C8C8;
  final float hitboxSpread = 1.4;
  final float centerCircle = 0.7;
  final float scanPadding = 1.1;
  final int unselectedAlpha = 95;
  final int gradientParts = 20;
  
  final float taa1Rate = PI/45; // Make taa1Rate always a third of taa2Rate
  final float taa2Rate = PI/15;
  final float tarFrames = 10;
  
  KnobControl(float x_, float y_, float r_, float a_, float sw_, color ccolor1_, color ccolor2_, float setAngle_, float initValue){
    super(x_, y_, r_, 3);
    a = a_; // half the amount of angle that is not drawn of the knob arc
    sw = sw_; // arc width
    primary = ccolor1_;
    secondary = ccolor2_;
    setAngle = setAngle_; // SetAngle should only be either 0 or PI
    knobAngle = initValue;
    echoes = new ArrayList<Echo>(); // Echoes are for animations
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
    }
    
      void resetKnobAngle(){
        knobAngle += PI;
      }
    
    void setColorValues(color pri, color sec){
      primary = pri;
      secondary = sec;
    }
    
    // Returns the value ratio of the current knob
    float getValue(){
      float value;
      if(setAngle == 0){
        if(knobAngle > a*1.1){
         value = map(knobAngle, a, PI, 0, 0.5);
         return value;
        }
        if(knobAngle < -1.1*a){
         value = map(knobAngle, -PI, -a, 0.5, 1.0);
         return value;
        }
      } else {
       value = map(knobAngle, a - PI, PI - a, 0, 1.0);
       return value;
      }
      // Ideally never returns zero
      return 0;
    }
  
   // Built to be ran every frame
   void animate(){
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
           stroke(primary);
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
           if((r * centerCircle - tar1)/tarFrames < 0.25){
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
         if((r * hitboxSpread - tar3)/tarFrames*2 < 0.000000005){
           animating = false;
           phaseSwitch = false;
           phases[2] = false;
         }
         
         drawBackgroundComponents(tar3);
         drawCenterComponents(tar1);
         drawArcComponents(tar2, true);
       }
     } else {
       drawKnob(); 
     }
   }
   
     // Drawing the functional Knob
     void drawKnob(){
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
         image(outerGlow, -r_/2, -r_/2, r_, r_);
         fill(primary);
       } else {
         fill(unselectedCenterButtonColor);
       }
       ellipse(0,0,r_,r_);
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
         stroke(primary);
       } else {
         stroke(primary, 95);
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
           stroke(primary);
         } else {
           stroke(primary, 95);
         }
         strokeWeight(sw);
         arc(0, 0, r_, r_, a, PI);
         arc(0, 0, r_, r_, -PI + 0.04, knobAngle);
         popMatrix();
         }
       } 
       
       // Small indication circle
       pushMatrix();
       translate(x,y);
       rotate(knobAngle - PI/2);
       noStroke();
       fill(255);
       ellipse(0,r_/2,sw*2,sw*2);
       popMatrix(); 
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
     
   void addEcho(){
     color temp;
     if(Math.abs(a) > PI/2){
       temp = secondary;
     } else {
       temp = primary;
     }
     Echo ce = new Echo(x,y,r,sw,temp);
     echoes.add(ce);
   }
   
   void detectPress(float x_, float y_){
     float temp = dist(x_, y_, x, y);
     
     if(temp < (r/2 * centerCircle)){
       pressed = true;
       
       // Toggling selection value
       if(selection){
        selection = false; 
       } else {
        selection = true; 
       }
     } else if(temp < (r/2 * hitboxSpread)){
       pressed = true;
     }
   }
   
   // In the future for multitouch, reference to the specific touch must be recorded at the top of the class
   void detectDrag(float x_, float y_){
     float tdist = dist(x_, y_, x, y);
     //if(tdist < (r/2 * hitboxSpread) && tdist > r/2 * centerCircle){
     if(pressed){
      float temp = atan2(y_ - y, x_ - x); // In the future of implementing multitouch, these would be the touch values instead of mouse values
      if(setAngle == 0){
        if(temp < a && temp > -a){
          if(temp + a >= a){
            temp = a;
            block = true;
          }
          if(temp - a <= -a){
            temp = -a;
            block = true;
          }
         }
       else{
         moveToMouseAngle(temp);
       }
      } else {
        if(temp > PI - a || temp < a - PI){
          if(temp + a >= 0){
            temp = PI - a;
            block = true;
          }
          if(temp - a <= 0){
            temp = a - PI;
           block = true; 
          }
        } else {
          moveToMouseAngle(temp);
        }
      }
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
     
   void detectRelease(){
     movable = false;
     pressed = false;
   }
}
