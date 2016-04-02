
ControlKnob k1 = new ControlKnob(150,100,100,5,100,#FFCC00);

void setup(){
  size(300,200);
}

void draw(){
  fill(128);
  noStroke();
  rect(0,0,300,200);
  k1.drawKnob();
  k1.moveKnob();
  textSize(16);
  fill(255);
  text(k1.getValue(), 150, 30);
}

void mousePressed(){
  k1.movable = true;
}

void mouseReleased(){
  k1.movable = false;
}
