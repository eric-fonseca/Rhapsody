class ControlKnob{
  float x, y, r, a, sw; // r is actually circle diameter. Oops, but its a little too late to change atm
  float setAngle, knobAngle;
  color primary, secondary;
  Boolean active = true; // Use this var to state is knob is interact able or drawn on sketch
  Boolean selected = false;
  Boolean movable = false;
  Boolean block = false;
  
  PImage outerGlow = loadImage("knobGlow.png");
  // Touch currentTouchReference;
  
  // Constant Ratios
  final color backgroundColor = #202020;
  final float hitboxSpread = 1.4;
  final float centerCircle = 0.7;
  final float scanPadding = 1.1;
  final int unselectedAlpha = 95;
  final int gradientParts = 20;
  
  ControlKnob(float x_, float y_, float r_, float a_, float sw_, color ccolor1_, color ccolor2_, float setAngle_, float initValue){
    x = x_;
    y = y_;
    r = r_;
    a = a_;
    sw = sw_;
    primary = ccolor1_;
    secondary = ccolor2_;
    setAngle = setAngle_; // SetAngle should only be either 0 or PI
    knobAngle = initValue;
  }
  
  void Knob(){
    // Background draw
    pushMatrix();
    translate(x,y);
    noStroke();
    fill(backgroundColor);
    ellipse(0,0,r*hitboxSpread, r*hitboxSpread);
    popMatrix();
    
    // Center circle
    pushMatrix();
    translate(x,y);
    noStroke();
    if(selected){
      image(outerGlow, -r/2, -r/2, r, r);
      fill(#F866F3);
    } else {
      fill(#C8C8C8);
    }
    ellipse(0,0,r * centerCircle,r * centerCircle);
    popMatrix();
    
    // Dull arc
    pushMatrix();
    translate(x, y);
    rotate(setAngle);
    noFill();
    stroke(200);
    strokeWeight(sw);
    arc(0, 0, r, r, a, 2*PI - a);
    popMatrix();
    
    pushMatrix();
    translate(x,y);
    rotate(setAngle);
    noFill();
    strokeWeight(sw+1);
    if(selected){
      float part = (PI - a)/gradientParts;
      for(int i = 1; i <= gradientParts; i++){
        stroke(map(i, 1, gradientParts, red(secondary), red(primary)),
               map(i, 1, gradientParts, green(secondary), green(primary)),
               map(i, 1, gradientParts, blue(secondary), blue(primary)));
        float temp;
        /*
        if(setAngle == 0){
          temp = map((i - 1), 0, gradientParts, a, knobAngle);
          if(knobAngle < a){
            println(temp);
            if(temp < 0){
              arc(0, 0, r, r, temp, PI);
            } else {
              arc(0, 0, r, r, a, PI);
            }
            arc(0, 0, r, r, -PI, knobAngle);
          } else {
            arc(0, 0, r, r, temp, knobAngle);
          }
        } else {*/
          temp = map((i - 1), 0, gradientParts, a, knobAngle + PI);
        //}
        arc(0, 0, r, r, temp, knobAngle + PI);
      }
    } else {
      stroke(primary, unselectedAlpha);
      arc(0, 0, r, r, a, knobAngle + PI);
    }
    popMatrix();
   
    /*
    // Highlight arc
    pushMatrix();
    translate(x,y);
    rotate(setAngle);
    noFill();
    if(selected){
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
      if(selected){
        stroke(primary);
      } else {
        stroke(primary, 95);
      }
      strokeWeight(sw);
      arc(0, 0, r, r, a, PI);
      arc(0, 0, r, r, -PI, knobAngle);
      popMatrix();
      }
    }
     */
    
    // Small indication circle
    pushMatrix();
    translate(x,y);
    rotate(knobAngle - PI/2);
    noStroke();
    fill(255);
    ellipse(0,r/2,sw*2,sw*2);
    popMatrix(); 
   }
   
   boolean switchSelection(float x_, float y_){
     if(dist(x_, y_, x, y) < (r/2 * centerCircle)){
       if(selected){
        selected = false; 
       } else {
        selected = true; 
       }
       return true;
     }
     return false;
   }
   
   // In the future for multitouch, reference to the specific touch must be recorded at the top of the class
   void isMouseOnKnob(float x_, float y_){
     float tdist = dist(x_, y_, x, y);
     if(tdist < (r/2 * hitboxSpread) && tdist > r/2 * centerCircle){
      float temp = atan2(mouseY - y, mouseX - x); // In the future of implementing multitouch, these would be the touch values instead of mouse values
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
}
