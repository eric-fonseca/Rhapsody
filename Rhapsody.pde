import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import vialab.SMT.*;
import vialab.SMT.util.*;
import vialab.SMT.event.*;
import vialab.SMT.renderer.*;
import vialab.SMT.swipekeyboard.*;
import processing.video.*;

// Screen Objects are globally accessible
public SongSelect songSelectScene;
public MainInterface mainInterfaceScene;

// Zone names have to be hardcoded - pretty icky looking
String[] zoneNames0 = {"TrackControl0", "KnobControl0-0", "KnobControl0-1", "KnobControl0-2", "DoubleControl0"};
String[] zoneNames1 = {"TrackControl1", "KnobControl1-0", "KnobControl1-1", "KnobControl1-2", "DoubleControl1"};
String[] zoneNames2 = {"TrackControl2", "KnobControl2-0", "KnobControl2-1", "KnobControl2-2", "DoubleControl2"};
String[] zoneNames3 = {"TrackControl3", "KnobControl3-0", "KnobControl3-1", "KnobControl3-2", "DoubleControl3"};
String[] zoneNames4 = {"TrackControl4", "KnobControl4-0", "KnobControl4-1", "KnobControl4-2", "DoubleControl4"};
String[] zoneNames5 = {"TrackControl5", "KnobControl5-0", "KnobControl5-1", "KnobControl5-2", "DoubleControl5"};
String[] zoneNames6 = {"TrackControl6", "KnobControl6-0", "KnobControl6-1", "KnobControl6-2", "DoubleControl6"};
String[][] zoneNames = {zoneNames0, zoneNames1, zoneNames2, zoneNames3, zoneNames4, zoneNames5, zoneNames6};

  
AudioControl audioControl;
Visualizer visualizer;
Minim minim;

void setup(){
  size(displayWidth, displayHeight,SMT.RENDERER);
  
  minim = new Minim(this);  
  SMT.smt_tempdir = new File(sketchPath("")+"/SMT");
  SMT.init(this, TouchSource.AUTOMATIC);
  SMT.setTouchDraw(TouchDraw.NONE);
  
  songSelectScene = new SongSelect(this);
  songSelectScene.init();
  songSelectScene.active = true;
  
  mainInterfaceScene = new MainInterface(0, 0);
  mainInterfaceScene.active = false;
}

void draw(){
  if(songSelectScene.active){
    songSelectScene.update();
  }
  if(mainInterfaceScene.active){
    mainInterfaceScene.update();
    //visualizer.update();
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

// These functions cannot be modular, so welcome to my function hell
// I blame the library, and this is not because I am bad at programming
  void drawTrackControl0(Zone zone){}
  void touchDownTrackControl0(Zone zone, Touch t){
    mainInterfaceScene.controls[0].passPress(t.getX(), t.getY());
  }
  void touchMovedTrackControl0(Zone zone, Touch t){
    mainInterfaceScene.controls[0].passDrag(t.getX(), t.getY());
  }
  void touchUpTrackControl0(Zone zone){
    mainInterfaceScene.controls[0].passRelease();
  }
  
  void drawTrackControl1(Zone zone){}
  void touchDownTrackControl1(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 1){
      mainInterfaceScene.controls[1].passPress(t.getX(), t.getY());
    }
  }
  void touchMovedTrackControl1(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 1){
      mainInterfaceScene.controls[1].passDrag(t.getX(), t.getY());
    }
  }
  void touchUpTrackControl1(Zone zone){
    if(mainInterfaceScene.nc >= 1){
      mainInterfaceScene.controls[1].passRelease();
    }
  }
  
  void drawTrackControl2(Zone zone){}
  void touchDownTrackControl2(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 2){
      mainInterfaceScene.controls[2].passPress(t.getX(), t.getY());
    }
  }
  void touchMovedTrackControl2(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 2){
      mainInterfaceScene.controls[2].passDrag(t.getX(), t.getY());
    }
  }
  void touchUpTrackControl2(Zone zone){
    if(mainInterfaceScene.nc >= 2){
      mainInterfaceScene.controls[2].passRelease();
    }
  }
  
  void drawTrackControl3(Zone zone){}
  void touchDownTrackControl3(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 3){
      mainInterfaceScene.controls[3].passPress(t.getX(), t.getY());
    }
  }
  void touchMovedTrackControl3(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 3){
      mainInterfaceScene.controls[3].passDrag(t.getX(), t.getY());
    }
  }
  
  void touchUpTrackControl3(Zone zone){
    if(mainInterfaceScene.nc >= 3){
      mainInterfaceScene.controls[3].passRelease();
    }
  }
  
  void drawTrackControl4(Zone zone){}
  void touchDownTrackControl4(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 4){
      mainInterfaceScene.controls[4].passPress(t.getX(), t.getY());
    }
  }
  void touchMovedTrackControl4(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 4){
      mainInterfaceScene.controls[4].passDrag(t.getX(), t.getY());
    }
  }
  void touchUpTrackControl4(Zone zone){
    if(mainInterfaceScene.nc >= 4){
      mainInterfaceScene.controls[4].passRelease();
    }
  }
  
  void drawTrackControl5(Zone zone){}
  void touchDownTrackControl5(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 5){
      mainInterfaceScene.controls[5].passPress(t.getX(), t.getY());
    }
  }
  void touchMovedTrackControl5(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 5){
    mainInterfaceScene.controls[5].passDrag(t.getX(), t.getY());
    }
  }
  void touchUpTrackControl5(Zone zone){
    if(mainInterfaceScene.nc >= 5){
      mainInterfaceScene.controls[5].passRelease();
    }
  }
  
  void drawTrackControl6(Zone zone){}
  void touchDownTrackControl6(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 6){
      mainInterfaceScene.controls[0].passPress(t.getX(), t.getY());
    }
  }
  void touchMovedTrackControl6(Zone zone, Touch t){
    if(mainInterfaceScene.nc >= 6){
      mainInterfaceScene.controls[0].passDrag(t.getX(), t.getY());
    }
  }
  void touchUpTrackControl6(Zone zone){
    if(mainInterfaceScene.nc >= 6){
      mainInterfaceScene.controls[0].passRelease();
    }
  }
    

