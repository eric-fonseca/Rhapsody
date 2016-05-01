import processing.video.*;

SongSelect songSelectScene;
static MainInterface mainInterfaceScene;

void setup(){
  size(displayWidth, displayHeight);
  songSelectScene = new SongSelect(this);
  songSelectScene.init();
  songSelectScene.active = true;
  
  mainInterfaceScene = new MainInterface(0,0);
}

void draw(){
  if(songSelectScene.active){
    songSelectScene.update();
  }
  if(mainInterfaceScene.active){
    mainInterfaceScene.update();
  }
}

void mousePressed(){
  if(songSelectScene.active){
    songSelectScene.handleMousePress(mouseX,mouseY);
  }
  if(mainInterfaceScene.active){
    mainInterfaceScene.handleMousePress(mouseX,mouseY);
  }
}

void mouseDragged(){
  if(mainInterfaceScene.active){
    mainInterfaceScene.handleMouseDrag(mouseX,mouseY);
  }
}

void mouseReleased(){
  if(mainInterfaceScene.active){
    mainInterfaceScene.handleMouseRelease();
  }
}

void movieEvent(Movie m) {
  m.read();
}
