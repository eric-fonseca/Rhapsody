class ControlKnob{
  float x, y, r, sw;
  float range, value;
  float setAngle, knobAngle;
  color ccolor;
  Boolean movable = false;
  Boolean block = false;
  
  ControlKnob(float x_, float y_, float r_, float sw_, float range_, color ccolor_){
    x = x_;
    y = y_;
    r = r_;
    sw = sw_;
    range = range_;
    ccolor = ccolor_;
    setAngle = 0;
    knobAngle = PI/4 + 0.01;
  }
  
  void drawKnob(){
    // Center circle
    pushMatrix();
    translate(x,y);
    noStroke();
    fill(200);
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
    arc(0, 0, r, r, PI/4, knobAngle);
    popMatrix();
    
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
  
  void moveKnob(){
    pushMatrix();
    translate(x,y);
    if(movable){
    float temp = atan2(mouseY - y, mouseX - x);
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
      if(!(knobAngle > temp && block)){
       knobAngle = temp;
       block = false;
      }
      if(!(knobAngle < temp && block)){
       knobAngle = temp;
       block = false;
      }
     }
    }
    rotate(knobAngle - PI/2);
    noStroke();
    fill(255);
    ellipse(0,r/2,sw*2,sw*2);
    popMatrix(); 
   }
   
   float getValue(){
     float value;
     if(knobAngle > PI/4.2){
      value = map(knobAngle, PI/4, PI, 0, 0.5);
      return value;
     }
     if(knobAngle < -PI/4.2){
      value = map(knobAngle, -PI, -PI/4, 0.5, 1.0);
      return value;
     }
     else{
      return 0; 
     }
   }
}
