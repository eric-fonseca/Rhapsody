import vialab.SMT.event.*;
import vialab.SMT.util.*;
import vialab.SMT.*;
import vialab.SMT.swipekeyboard.*;
import vialab.SMT.renderer.*;

MainInterface cc;

void setup(){
  size(displayWidth, displayHeight, SMT.RENDERER);
  
  SMT.smt_tempdir = new File(sketchPath("")+"/SMT");
  SMT.init(this, TouchSource.AUTOMATIC);
  SMT.setTouchDraw(TouchDraw.NONE);
  //SMT.setWarnUnimplemented(false);
  
  cc = new MainInterface(width/2,height/2, height/3, 4);
  for(int i = 0; i < cc.zones.size(); i++){
    SMT.add(cc.zones.get(i));
  }
  //SMTUtilities.loadMethods();
}

void draw(){
  fill(0);
  noStroke();
  rect(0,0,width,height);
  cc.drawAll();
  for(Zone zone : SMT.getZones()){
    println(zone.getIds());
  }
}

/*
void mousePressed(){
 cc.passMousePress(mouseX, mouseY); 
}

void mouseDragged(){
  cc.passMouseDrag(mouseX, mouseY);
}

void mouseReleased(){
 cc.passMouseRelease(); 
}
*/

