
ControlKnob k1 = new ControlKnob(225,100,100,5,#FFCC00, 0); // last parameter 0, for right sided
ControlKnob k2 = new ControlKnob(75,100,100,5,#CCFF00, PI); // last parameter PI, for left sided
                                                            // Use only these two settings on rotation

void setup(){
  size(300,200);
}

void draw(){
  fill(128);
  noStroke();
  rect(0,0,300,200);
  // simple Knob() call to turn on all associated drawing
  k1.Knob();
  k2.Knob();
  // Knobs return values from 0 to 1
  textSize(16);
  fill(255);
  text(k1.getValue(), 200, 30);
  textSize(16);
  fill(255);
  text(k2.getValue(), 50, 30);
}

// Dont forget to put these functions down. The logic behind multitouch might be different though, look through Knob class for details
void mousePressed(){
  
  k1.isMouseOnKnob(mouseX, mouseY);
  k2.isMouseOnKnob(mouseX, mouseY);
}

// Logic here will change with multi-touch
void mouseReleased(){
  k1.movable = false;
  k2.movable = false;
}
