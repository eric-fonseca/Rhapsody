MainInterface cc;

void setup(){
  size(displayWidth, displayHeight);
  cc = new MainInterface(width/2,height/2, height/3, 4);
}

void draw(){
  fill(0);
  noStroke();
  rect(0,0,width,height);
  cc.drawAll();
}

void mousePressed(){
 cc.passMousePress(mouseX, mouseY); 
}

void mouseDragged(){
  cc.passMouseDrag(mouseX, mouseY);
}

void mouseReleased(){
 cc.passMouseRelease(); 
}


