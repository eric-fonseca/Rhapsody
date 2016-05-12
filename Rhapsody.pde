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
import processing.net.*;

// Screen Objects are globally accessible
public SongSelect songSelectScene;
public MainInterface mainInterfaceScene;
public Transition TransitionIn, TransitionOut;

// Zone names have to be hardcoded - pretty icky looking
private String[] zoneNames0 = {"TrackControl0", "KnobControl00", "KnobControl01", "KnobControl02", "DoubleControl0"};
private String[] zoneNames1 = {"TrackControl1", "KnobControl10", "KnobControl11", "KnobControl12", "DoubleControl1"};
private String[] zoneNames2 = {"TrackControl2", "KnobControl20", "KnobControl21", "KnobControl22", "DoubleControl2"};
private String[] zoneNames3 = {"TrackControl3", "KnobControl30", "KnobControl31", "KnobControl32", "DoubleControl3"};
private String[] zoneNames4 = {"TrackControl4", "KnobControl40", "KnobControl41", "KnobControl42", "DoubleControl4"};
private String[] zoneNames5 = {"TrackControl5", "KnobControl50", "KnobControl51", "KnobControl52", "DoubleControl5"};
private String[] zoneNames6 = {"TrackControl6", "KnobControl60", "KnobControl61", "KnobControl62", "DoubleControl6"};
public String[][] zoneNames = {zoneNames0, zoneNames1, zoneNames2, zoneNames3, zoneNames4, zoneNames5, zoneNames6};
  
AudioControl audioControl;
Visualizer visualizer;
Minim minim;

Server server;
String songData = "";

void setup(){
  minim = new Minim(this);
  
  size(displayWidth, displayHeight, SMT.RENDERER);
  
  SMT.smt_tempdir = new File(sketchPath("")+"/SMT");
  SMT.init(this, TouchSource.AUTOMATIC);
  SMT.setTouchDraw(TouchDraw.NONE);
  
  songSelectScene = new SongSelect(this);
  songSelectScene.init();
  songSelectScene.active = true;
  
  mainInterfaceScene = new MainInterface(0, zoneNames0); //this is unused, we just need a dummy array
  mainInterfaceScene.active = false;
  
  TransitionIn = new Transition(this, "songChosen.mp4", false);
  TransitionOut = new Transition(this, "songOutro.mp4", true);
  
  server = new Server(this, 5204);
}

void draw(){
  if(songSelectScene.active){
    songSelectScene.update();
  }
  if(mainInterfaceScene.active){
    mainInterfaceScene.update();
  }
  if(TransitionIn.active){
    TransitionIn.update();
  }
  if(TransitionOut.active){
    TransitionOut.update();
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

  // Functions for Song Selection Screen
  void drawBackButton(Zone zone){
    zone.drag(false,false);
  }
  void touchDownBackButton(Zone zone, Touch t){
    mainInterfaceScene.handleBackButtonPress();
  }
  void touchUpBackButton(Zone zone, Touch t){
    mainInterfaceScene.handleBackButtonRelease(); 
  }
  void drawConfirmButton(Zone zone){
    zone.drag(false,false);
  }
  void touchDownConfirmButton(Zone zone, Touch t){
    mainInterfaceScene.handleConfirmButtonPress();
  }
  
  void drawAlbumCircle(Zone zone){
    zone.drag(false,false); 
  }
  void touchDownAlbumCircle(Zone zone, Touch t){
     songSelectScene.handleAlbumCirclePress(t.getX(), t.getY());
  }
  void drawRightTriangle(Zone zone){
    zone.drag(false,false);
  }
  void touchDownRightTriangle(Zone zone, Touch t){
    songSelectScene.handleRightArrowPress();
  }
  void drawLeftTriangle(Zone zone){
    zone.drag(false,false);
  }
  void touchDownLeftTriangle(Zone zone, Touch t){
    songSelectScene.handleLeftArrowPress();
  }
  void drawExitButton(Zone zone){
    zone.drag(false,false); 
  }
  void touchDownExitButton(Zone zone, Touch t){
    songSelectScene.handleExitButtonPress(t.getX(), t.getY()); 
  }
  void drawJamButton(Zone zone){
    zone.drag(false,false); 
  }
  void touchDownJamButton(Zone zone, Touch t){
    songSelectScene.handleJamButtonPress(t.getX(), t.getY()); 
  }
   
  // Functions for Main Interface
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
  
    void drawKnobControl00(Zone zone){}
    void touchDownKnobControl00(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[0].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl00(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[0].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl00(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[0].passRelease();
    }
    
    void drawKnobControl01(Zone zone){}
    void touchDownKnobControl01(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[1].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl01(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[1].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl01(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[1].passRelease();
    }
    
    void drawKnobControl02(Zone zone){}
    void touchDownKnobControl02(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[2].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl02(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[2].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl02(Zone zone, Touch t){
      mainInterfaceScene.controls[0].knobs[2].passRelease();
    }
    
    void drawDoubleControl0(){}
    void touchDownDoubleControl0(Zone zone, Touch t){
      mainInterfaceScene.controls[0].doubleBar.detectPress(t.getX(), t.getY());
    }
    void touchMovedDoubleControl0(Zone zone, Touch t){
      mainInterfaceScene.controls[0].doubleBar.detectDrag(t.getX(), t.getY());
    }
    void touchUpDoubleControl0(Zone zone, Touch t){
      mainInterfaceScene.controls[0].doubleBar.detectRelease();
    }
  
  void drawTrackControl1(Zone zone){}
  void touchDownTrackControl1(Zone zone, Touch t){
    mainInterfaceScene.controls[1].passPress(t.getX(), t.getY());
  }
  void touchMovedTrackControl1(Zone zone, Touch t){
    mainInterfaceScene.controls[1].passDrag(t.getX(), t.getY());
  }
  void touchUpTrackControl1(Zone zone){
    mainInterfaceScene.controls[1].passRelease();
  }
  
    void drawKnobControl10(Zone zone){}
    void touchDownKnobControl10(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[0].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl10(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[0].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl10(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[0].passRelease();
    }
    
    void drawKnobControl11(Zone zone){}
    void touchDownKnobControl11(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[1].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl11(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[1].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl11(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[1].passRelease();
    }
    
    void drawKnobControl12(Zone zone){}
    void touchDownKnobControl12(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[2].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl12(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[2].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl12(Zone zone, Touch t){
      mainInterfaceScene.controls[1].knobs[2].passRelease();
    }
    
    void drawDoubleControl1(){}
    void touchDownDoubleControl1(Zone zone, Touch t){
      mainInterfaceScene.controls[1].doubleBar.detectPress(t.getX(), t.getY());
    }
    void touchMovedDoubleControl1(Zone zone, Touch t){
      mainInterfaceScene.controls[1].doubleBar.detectDrag(t.getX(), t.getY());
    }
    void touchUpDoubleControl1(Zone zone, Touch t){
      mainInterfaceScene.controls[1].doubleBar.detectRelease();
    }
  
  void drawTrackControl2(Zone zone){}
  void touchDownTrackControl2(Zone zone, Touch t){
    mainInterfaceScene.controls[2].passPress(t.getX(), t.getY());
  }
  void touchMovedTrackControl2(Zone zone, Touch t){
    mainInterfaceScene.controls[2].passDrag(t.getX(), t.getY());
  }
  void touchUpTrackControl2(Zone zone){
    mainInterfaceScene.controls[2].passRelease();
  }
  
    void drawKnobControl20(Zone zone){}
    void touchDownKnobControl20(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[0].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl20(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[0].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl20(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[0].passRelease();
    }
    
    void drawKnobControl21(Zone zone){}
    void touchDownKnobControl21(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[1].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl21(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[1].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl21(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[1].passRelease();
    }
    
    void drawKnobControl22(Zone zone){}
    void touchDownKnobControl22(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[2].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl22(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[2].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl22(Zone zone, Touch t){
      mainInterfaceScene.controls[2].knobs[2].passRelease();
    }
    
    void drawDoubleControl2(){}
    void touchDownDoubleControl2(Zone zone, Touch t){
      mainInterfaceScene.controls[2].doubleBar.detectPress(t.getX(), t.getY());
    }
    void touchMovedDoubleControl2(Zone zone, Touch t){
      mainInterfaceScene.controls[2].doubleBar.detectDrag(t.getX(), t.getY());
    }
    void touchUpDoubleControl2(Zone zone, Touch t){
      mainInterfaceScene.controls[2].doubleBar.detectRelease();
    }
  
  void drawTrackControl3(Zone zone){}
  void touchDownTrackControl3(Zone zone, Touch t){
    mainInterfaceScene.controls[3].passPress(t.getX(), t.getY());
  }
  void touchMovedTrackControl3(Zone zone, Touch t){
    mainInterfaceScene.controls[3].passDrag(t.getX(), t.getY());
  }
  
  void touchUpTrackControl3(Zone zone){
    mainInterfaceScene.controls[3].passRelease();
  }
  
      void drawKnobControl30(Zone zone){}
    void touchDownKnobControl30(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[0].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl30(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[0].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl30(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[0].passRelease();
    }
    
    void drawKnobControl31(Zone zone){}
    void touchDownKnobControl31(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[1].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl31(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[1].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl31(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[1].passRelease();
    }
    
    void drawKnobControl32(Zone zone){}
    void touchDownKnobControl32(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[2].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl32(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[2].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl32(Zone zone, Touch t){
      mainInterfaceScene.controls[3].knobs[2].passRelease();
    }
    
    void drawDoubleControl3(){}
    void touchDownDoubleControl3(Zone zone, Touch t){
      mainInterfaceScene.controls[3].doubleBar.detectPress(t.getX(), t.getY());
    }
    void touchMovedDoubleControl3(Zone zone, Touch t){
      mainInterfaceScene.controls[3].doubleBar.detectDrag(t.getX(), t.getY());
    }
    void touchUpDoubleControl3(Zone zone, Touch t){
      mainInterfaceScene.controls[3].doubleBar.detectRelease();
    }
  
  void drawTrackControl4(Zone zone){}
  void touchDownTrackControl4(Zone zone, Touch t){
    mainInterfaceScene.controls[4].passPress(t.getX(), t.getY());
  }
  void touchMovedTrackControl4(Zone zone, Touch t){
    mainInterfaceScene.controls[4].passDrag(t.getX(), t.getY());
  }
  void touchUpTrackControl4(Zone zone){
    mainInterfaceScene.controls[4].passRelease();
  }
  
    void drawKnobControl40(Zone zone){}
    void touchDownKnobControl40(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[0].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl40(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[0].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl40(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[0].passRelease();
    }
    
    void drawKnobControl41(Zone zone){}
    void touchDownKnobControl41(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[1].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl41(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[1].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl41(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[1].passRelease();
    }
    
    void drawKnobControl42(Zone zone){}
    void touchDownKnobControl42(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[2].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl42(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[2].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl42(Zone zone, Touch t){
      mainInterfaceScene.controls[4].knobs[2].passRelease();
    }
    
    void drawDoubleControl4(){}
    void touchDownDoubleControl4(Zone zone, Touch t){
      mainInterfaceScene.controls[4].doubleBar.detectPress(t.getX(), t.getY());
    }
    void touchMovedDoubleControl4(Zone zone, Touch t){
      mainInterfaceScene.controls[4].doubleBar.detectDrag(t.getX(), t.getY());
    }
    void touchUpDoubleControl4(Zone zone, Touch t){
      mainInterfaceScene.controls[4].doubleBar.detectRelease();
    }
  
  void drawTrackControl5(Zone zone){}
  void touchDownTrackControl5(Zone zone, Touch t){
    mainInterfaceScene.controls[5].passPress(t.getX(), t.getY());
  }
  void touchMovedTrackControl5(Zone zone, Touch t){
    mainInterfaceScene.controls[5].passDrag(t.getX(), t.getY());
  }
  void touchUpTrackControl5(Zone zone){
    mainInterfaceScene.controls[5].passRelease();
  }
  
    void drawKnobControl50(Zone zone){}
    void touchDownKnobControl50(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[0].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl50(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[0].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl50(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[0].passRelease();
    }
    
    void drawKnobControl51(Zone zone){}
    void touchDownKnobControl51(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[1].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl51(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[1].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl51(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[1].passRelease();
    }
    
    void drawKnobControl52(Zone zone){}
    void touchDownKnobControl52(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[2].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl52(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[2].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl52(Zone zone, Touch t){
      mainInterfaceScene.controls[5].knobs[2].passRelease();
    }
    
    void drawDoubleControl5(){}
    void touchDownDoubleControl5(Zone zone, Touch t){
      mainInterfaceScene.controls[5].doubleBar.detectPress(t.getX(), t.getY());
    }
    void touchMovedDoubleControl5(Zone zone, Touch t){
      mainInterfaceScene.controls[5].doubleBar.detectDrag(t.getX(), t.getY());
    }
    void touchUpDoubleControl5(Zone zone, Touch t){
      mainInterfaceScene.controls[5].doubleBar.detectRelease();
    }
  
  void drawTrackControl6(Zone zone){}
  void touchDownTrackControl6(Zone zone, Touch t){
    mainInterfaceScene.controls[0].passPress(t.getX(), t.getY());
  }
  void touchMovedTrackControl6(Zone zone, Touch t){
    mainInterfaceScene.controls[0].passDrag(t.getX(), t.getY());
  }
  void touchUpTrackControl6(Zone zone){
    mainInterfaceScene.controls[0].passRelease();
  }
  
    void drawKnobControl60(Zone zone){}
    void touchDownKnobControl60(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[0].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl60(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[0].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl60(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[0].passRelease();
    }
    
    void drawKnobControl61(Zone zone){}
    void touchDownKnobControl61(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[1].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl61(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[1].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl61(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[1].passRelease();
    }
    
    void drawKnobControl62(Zone zone){}
    void touchDownKnobControl62(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[2].passPress(t.getX(), t.getY());
    }
    void touchMovedKnobControl62(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[2].passDrag(t.getX(), t.getY());
    }
    void touchUpKnobControl62(Zone zone, Touch t){
      mainInterfaceScene.controls[6].knobs[2].passRelease();
    }
    
    void drawDoubleControl6(){}
    void touchDownDoubleControl6(Zone zone, Touch t){
      mainInterfaceScene.controls[6].doubleBar.detectPress(t.getX(), t.getY());
    }
    void touchMovedDoubleControl6(Zone zone, Touch t){
      mainInterfaceScene.controls[6].doubleBar.detectDrag(t.getX(), t.getY());
    }
    void touchUpDoubleControl6(Zone zone, Touch t){
      mainInterfaceScene.controls[6].doubleBar.detectRelease();
    }
    

