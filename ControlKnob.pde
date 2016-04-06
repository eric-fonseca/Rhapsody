class ControlKnob{
  float x, y, r, sw;
  float setAngle, knobAngle;
  color ccolor;
  Boolean movable = false;
  Boolean block = false;
  // Touch currentTouchReference;
  
  ControlKnob(float x_, float y_, float r_, float sw_, color ccolor_, float setAngle_, float knobAngle_){
    x = x_;
    y = y_;
    r = r_;
    sw = sw_;
    ccolor = ccolor_;
    setAngle = setAngle_; // SetAngle should only be either 0 or PI
    knobAngle = knobAngle_;
    if(setAngle == 0){
      knobAngle = PI/4 + knobAngle_*PI*1.5 + 0.01;
    } else {
      knobAngle = -3 * PI/4 + knobAngle_*PI*1.5 + 0.01; 
    }
  }
  
  void Knob(){
    // Center circle
    pushMatrix();
    translate(x,y);
    noStroke();
    
    fill(38,38,38);
    ellipse(0,0,r*1.3,r*1.3);
    
    if(movable){
      fill(ccolor, 95);
    } else {
      fill(#C8C8C8);
    }
    
    ellipse(0,0,r/2,r/2);
    popMatrix();
    
    // Dull arc
    pushMatrix();
    translate(x, y);
    rotate(setAngle);
    noFill();
    stroke(200);
    strokeWeight(sw);
    arc(0, 0, r, r, PI/4, 7 * PI/4);
    popMatrix();
    
    // Highlight arc
    pushMatrix();
    translate(x,y);
    rotate(setAngle);
    noFill();
    stroke(ccolor);
    strokeWeight(sw);
    if(setAngle == 0){
      arc(0, 0, r, r, PI/4, knobAngle);
    } else {
      arc(0, 0, r, r, PI/4, knobAngle + PI);
    }
    popMatrix();
    
    // Second hightlight arc, sometimes needed due to processing's rotation handling
    if(setAngle == 0){
      if(knobAngle < PI/4){
      pushMatrix();
      translate(x,y);
      rotate(setAngle);
      noFill();
      stroke(ccolor);
      strokeWeight(sw);
      arc(0, 0, r, r, PI/4, PI);
      arc(0, 0, r, r, -PI, knobAngle);
      popMatrix();
      }
    }
    
    pushMatrix();
    translate(x,y);
    if(movable){
    float temp = atan2(mouseY - y, mouseX - x); // In the future of implementing multitouch, these would be the touch values instead of mouse values
      if(setAngle == 0){
        if(temp < PI/4 && temp > -PI/4){
          if(temp + PI/4 >= PI/4){
            temp = PI/4;
            block = true;
          }
          if(temp - PI/4 <= -PI/4){
            temp = -PI/4;
            block = true;
          }
         }
       else{
         moveToMouseAngle(temp);
       }
      } else {
        if(temp > 3 * PI/4 || temp < -3 * PI/4){
          if(temp + PI/4 >= 0){
            temp = 3 * PI/4;
            block = true;
          }
          if(temp - PI/4 <= 0){
            temp = -3 * PI/4;
           block = true; 
          }
        } else {
          moveToMouseAngle(temp);
        }
      }
    }
    rotate(knobAngle - PI/2);
    noStroke();
    fill(255);
    ellipse(0,r/2,sw*2.5,sw*2.5);
    popMatrix(); 
   }
   
     // support function
     void moveToMouseAngle(float temp){
       if(!(knobAngle > temp && block)){
           knobAngle = temp;
           block = false;
       }
       if(!(knobAngle < temp && block)){
         knobAngle = temp;
         block = false;
       }
     }
   
   float getValue(){
     float value;
     if(setAngle == 0){
       if(knobAngle > PI/4.2){
        value = map(knobAngle, PI/4, PI, 0, 0.5);
        return value;
       }
       if(knobAngle < -PI/4.2){
        value = map(knobAngle, -PI, -PI/4, 0.5, 1.0);
        return value;
       }
     } else {
      value = map(knobAngle, -3 * PI/4, 3 * PI/4, 0, 1.0);
      return value;
     }
     // Ideally never returns zero
     return 0;
   }
   
   // In the future for multitouch, reference to the specific touch must be recorded at the top of the class
   void isMouseOnKnob(float x_, float y_){
     if(dist(x_, y_, x, y) < r/1.5){
       movable = true;
     } else {
       movable = false; 
     }
   }
}
