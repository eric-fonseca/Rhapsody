class ControlKnob{
  float x, y, r, sw;
  float range, value;
  color ccolor;
  
  ControlKnob(float x_, float y_, float r_, float sw_, float range_, color ccolor_){
    x = x_;
    y = y_;
    r = r_;
    sw = sw_;
    range = range_;
    ccolor = ccolor_;
  }
  
  void drawKnob(){
    pushMatrix();
    noFill();
    stroke(ccolor);
    strokeWeight(sw);
    ellipse(x, y, r, r);
    popMatrix();
  }
  
  void moveKnob(){
   pushMatrix();
   translate(x,y);
   float a = atan2(mouseY - y, mouseX - x);
   rotate(a - PI/2);
   //translate(x,y + r);
   noStroke();
   fill(ccolor);
   ellipse(0,r/2,sw*4, sw*4);
   popMatrix(); 
  }
}
