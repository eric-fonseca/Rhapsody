import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import processing.video.*;

// Screen Objects are static
static SongSelect songSelectScene;
static MainInterface mainInterfaceScene;
  
AudioControl audioControl;
Visualizer visualizer;
Minim minim;

void setup(){
  minim = new Minim(this);
  
  size(displayWidth, displayHeight);
  songSelectScene = new SongSelect(this);
  songSelectScene.init();
  songSelectScene.active = true;
  
  mainInterfaceScene = new MainInterface(0, 0);
  mainInterfaceScene.active = false;
  
  //allowing resizing of screen
  /*if (frame != null) {
    frame.setResizable(true);
  }*/
}

void draw(){
  if(songSelectScene.active){
    songSelectScene.update();
  }
  if(mainInterfaceScene.active){
    mainInterfaceScene.update();
    visualizer.update();
  }
}

void mousePressed(){
  if(songSelectScene.active){
    songSelectScene.handlePress(mouseX,mouseY);
  }
  if(mainInterfaceScene.active){
    mainInterfaceScene.handlePress(mouseX,mouseY);
  }
}

void mouseDragged(){
  if(mainInterfaceScene.active){
    mainInterfaceScene.handleDrag(mouseX,mouseY);
  }
}

void mouseReleased(){
  if(mainInterfaceScene.active){
    mainInterfaceScene.handleRelease();
  }
}

void movieEvent(Movie m) {
  m.read();
}
