ControlCenter cc = new ControlCenter(400,300, 250, 4);

void setup(){
  size(800,600);
}

void draw(){
  fill(0);
  noStroke();
  rect(0,0,800,600);
  cc.drawAll();
}

void mousePressed(){
 cc.detectPress(mouseX, mouseY); 
}

void mouseDragged(){
  cc.detectDrag(mouseX, mouseY);
}

void mouseReleased(){
 cc.detectRelease(); 
}


