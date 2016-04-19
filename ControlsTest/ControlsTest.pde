ControlCenter cc;

void setup(){
  size(1000,600);
  cc = new ControlCenter(width/2,height/2, 250, 4);
}

void draw(){
  fill(0);
  noStroke();
  rect(0,0,width,height);
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


