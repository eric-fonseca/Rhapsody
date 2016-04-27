import vialab.SMT.event.*;
import vialab.SMT.util.*;
import vialab.SMT.*;
import vialab.SMT.swipekeyboard.*;
import vialab.SMT.renderer.*;

MainInterface cc;

void setup(){
  size(1000,600,SMT.RENDERER);
  cc = new MainInterface(width/2,height/2, 250, 4);
  
  SMT.smt_tempdir = new File(sketchPath("")+"/SMT");
  SMT.init(this, TouchSource.AUTOMATIC);
  SMT.setTouchDraw(TouchDraw.NONE);
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


