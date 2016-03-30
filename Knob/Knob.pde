
ControlKnob k1 = new ControlKnob(100,100,50,5,100,#FFCC00);


void setup(){
  size(300,200);
}

void draw(){
  fill(#FFFFFF);
  noStroke();
  rect(0,0,300,200);
  k1.drawKnob();
  k1.moveKnob();
  
  textSize(16);
  fill(0, 102, 154);
  String s = "mouseX: " + mouseX + ", mouseY: " + mouseY; 
  text(s, 10, 30);
}
