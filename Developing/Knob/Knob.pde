
//ControlKnob k1 = new ControlKnob(225,100,100,PI/4,5, color(255,46,135), color(247, 255, 58), 0); // last parameter 0, for right sided
ControlKnob k2 = new ControlKnob(75,100,100,PI/8,5, color(247, 255, 58), color(255,46,135), PI); // last parameter PI, for left sided
                                                            // Use only these two settings on rotation

void setup(){
  size(300,200);
}

void draw(){
  fill(128);
  noStroke();
  rect(0,0,300,200);
  // simple Knob() call to turn on all associated drawing
  //k1.Knob();
  k2.Knob();
  // Knobs return values from 0 to 1
  //textSize(16);
  //fill(255);
  //text(k1.getValue(), 200, 30);
  textSize(16);
  fill(255);
  text(k2.getValue(), 50, 30);
}

void mousePressed(){
  //k1.switchSelection(mouseX, mouseY);
  k2.switchSelection(mouseX, mouseY);
}

// Dont forget to put these functions down. The logic behind multitouch might be different though, look through Knob class for details
void mouseDragged(){
  //k1.isMouseOnKnob(mouseX, mouseY);
  k2.isMouseOnKnob(mouseX, mouseY);
}


// Logic here will change with multi-touch
void mouseReleased(){

}
