// Dial knob for the user to change how effects are changing the audio track
class KnobControl extends Control{
  float a, sw;
  float setAngle, knobAngle;
  color primary, secondary;
  Boolean active = false; // Use this var to state is knob is interact-able or drawn on sketch
  Boolean movable = false;
  Boolean block = false;
  PImage outerGlow = loadImage("knobGlow.png");
  
  // Constant Ratios
  final color unpressedbackgroundColor = #202020;
  final color pressedbackgroundColor = #404040;
  final color unselectedCenterButtonColor = #C8C8C8;
  final float hitboxSpread = 1.4;
  final float centerCircle = 0.7;
  final float scanPadding = 1.1;
  final int unselectedAlpha = 95;
  final int gradientParts = 20;
  
  KnobControl(float x_, float y_, float r_, float a_, float sw_, color ccolor1_, color ccolor2_, float setAngle_, float initValue){
    super(x_, y_, r_);
    a = a_; // half the amount of angle that is not drawn of the knob arc
    sw = sw_; // arc width
    primary = ccolor1_;
    secondary = ccolor2_;
    setAngle = setAngle_; // SetAngle should only be either 0 or PI
    knobAngle = initValue;
  }
  
    void setNewPosition(float x_, float y_, float setAngle_){
      x = x_;
      y = y_;
      setAngle = setAngle_; // SetAngle should only be either 0 or PI
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
  void drawKnob(){
    // Background draw
    pushMatrix();
    translate(x,y);
    noStroke();
    if(pressed){
      fill(pressedbackgroundColor);
    } else {
      fill(unpressedbackgroundColor);
    }
    
    ellipse(0,0,r*hitboxSpread, r*hitboxSpread);
    popMatrix();
    
    // Center circle switch
    pushMatrix();
    translate(x,y);
    noStroke();
    if(selection){
      image(outerGlow, -r/2, -r/2, r, r);
      fill(primary);
    } else {
      fill(unselectedCenterButtonColor);
    }
    ellipse(0,0,r * centerCircle,r * centerCircle);
    popMatrix();
    
    // Dull arc for unselected status
    pushMatrix();
    translate(x, y);
    rotate(setAngle);
    noFill();
    stroke(unselectedCenterButtonColor);
    strokeWeight(sw);
    if(setAngle == 0){
      if(knobAngle > 0){
        arc(0, 0, r, r, knobAngle, PI);
        arc(0, 0, r, r, -PI, -a);
      } else {
        arc(0, 0, r, r, knobAngle, -a);
      }
    } else {
      arc(0, 0, r, r, knobAngle + PI, 2*PI - a);
    }
    popMatrix();
    
    // Highlight arc
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
    if(setAngle == 0){
      arc(0, 0, r, r, a, knobAngle);
    } else {
      arc(0, 0, r, r, a, knobAngle + PI);
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
      arc(0, 0, r, r, a, PI);
      arc(0, 0, r, r, -PI + 0.06, knobAngle);
      popMatrix();
      }
    }
     
    // Small indication circle
    pushMatrix();
    translate(x,y);
    rotate(knobAngle - PI/2);
    noStroke();
    fill(255);
    ellipse(0,r/2,sw*2,sw*2);
    popMatrix(); 
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
