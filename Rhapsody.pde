import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import controlP5.*;
import processing.net.*;

/*
Possible effects:
Gain
Delay
Flanger
Distortion (bitcrush?)
Vocoder (on vocal tracks)
Filters (frequency)
*/

Minim minim;
ControlP5 cp5;

String[] rhcpTracks = {"drums1", "drums2", "drums3", "guitar", "rhythm", "vocals"};
int[] rhcpColors = {#FD756D, #FD756D, #FD756D, #F7FF3A, #FF2E87, #FABA54};
FilePlayer[] rhcpPlayer = new FilePlayer[rhcpTracks.length];

Gain[] gain = new Gain[rhcpTracks.length];
Delay[] delay = new Delay[rhcpTracks.length];
boolean[] delayIsPatched = new boolean[rhcpTracks.length];

Flanger[] flanger = new Flanger[rhcpTracks.length];

MoogFilter[] highpass = new MoogFilter[rhcpTracks.length];
MoogFilter[] lowpass = new MoogFilter[rhcpTracks.length];

Vocoder[] vocoder = new Vocoder[rhcpTracks.length];
BitCrush[] bitcrush = new BitCrush[rhcpTracks.length];
boolean[] vocoderIsPatched = new boolean[rhcpTracks.length];
Oscil[] wave = new Oscil[rhcpTracks.length];

AudioOutput[] out = new AudioOutput[rhcpTracks.length];

ControlKnob[] gainKnob = new ControlKnob[rhcpTracks.length];
ControlKnob[] delayKnob = new ControlKnob[rhcpTracks.length];
ControlKnob[] vocoderKnob = new ControlKnob[rhcpTracks.length];

int r = 200;
float rad = 70;

Server server;
String songData = "";

void setup() {
  size(1280,800);
  
  background(38,38,38);
  
  server = new Server(this, 5204); 
  
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  
  for(int i = 0; i < rhcpPlayer.length; i++){
    out[i] = minim.getLineOut();
    
    rhcpPlayer[i] = new FilePlayer(minim.loadFileStream("audio/" + rhcpTracks[i] + ".mp3", 1024, true));
    
    gain[i] = new Gain(0);
    
    //Delay(float maxDelayTime, float amplitudeFactor, boolean feedBackOn, boolean passAudioOn)
    delay[i] = new Delay(0.5f, 0.5f, true, true);
    delayIsPatched[i] = false;
    
    flanger[i] = new Flanger( 1,      // delay length in milliseconds ( clamped to [0,100] )
                              0.2f,   // lfo rate in Hz ( clamped at low end to 0.001 )
                              1,      // delay depth in milliseconds ( minimum of 0 )
                              0.5f,   // amount of feedback ( clamped to [0,1] )
                              0.5f,   // amount of dry signal ( clamped to [0,1] )
                              0.5f    // amount of wet signal ( clamped to [0,1] )
    );
    
    highpass[i] = new MoogFilter(20, 0.5, MoogFilter.Type.HP);
    lowpass[i] = new MoogFilter(20000, 0.5, MoogFilter.Type.LP);
    
    vocoder[i] = new Vocoder(1024, 8);
    bitcrush[i] = new BitCrush(4, 3000);
    vocoderIsPatched[i] = false;
    wave[i] = new Oscil(100, 0.8, Waves.SAW);
                  
    gainKnob[i] = new ControlKnob(150, i*130+60, 65, PI/8, 5, color(247, 255, 58), color(255,46,135), PI, 0); 
    delayKnob[i] = new ControlKnob(250, i*130+60, 65, PI/8, 5, color(247, 255, 58), color(255,46,135), PI, -0.8); 
    vocoderKnob[i] = new ControlKnob(350, i*130+60, 65, PI/8, 5, color(247, 255, 58), color(255,46,135), PI, -2);
                  
    cp5.addRange(rhcpTracks[i] + " Filter", 20, 20000, 125, i*130+105, 260, 20)
                  .setLabel("")
                  .setColorForeground(#A93ABC)
                  .setColorBackground(#a5a5a5)
                  .setColorActive(#c864d9);
  }
  
  //separate loop so all tracks can load first
  for(int i = 0; i < rhcpPlayer.length; i++){
    rhcpPlayer[i].rewind();
    rhcpPlayer[i].play();
    rhcpPlayer[i].patch(gain[i]).patch(highpass[i]).patch(lowpass[i])/*.patch(flanger[i])*/.patch(out[i]);
  }
}

void controlEvent(ControlEvent controlEvent) {
  for(int i = 0; i < rhcpTracks.length; i++){
    if(controlEvent.isFrom(rhcpTracks[i] + " Filter")){
      highpass[i].frequency.setLastValue(controlEvent.getController().getArrayValue(0));
      lowpass[i].frequency.setLastValue(controlEvent.getController().getArrayValue(1));
    }
  }
}

void draw() {
  songData = "";
  
  pushMatrix();
  
  fill(#1A1F18, 20);
  noStroke();
  rect(0,0,width,height);
  translate(width*0.68, height/2);
  
  for(int i = 0; i < rhcpTracks.length; i++){
    switch(i){
      //Drums
      case 0:
      case 1:
      case 2:
        r = 175;
        break;
      // Lead-Guitar
      case 3:
        r = 275;
        break;
      // Rhythm-Guitar
      case 4:
        r = 125;
        break;
      // Vocals
      case 5:
        r = 225;
        break;
    }
    
    noFill();
    fill(rhcpColors[i], 10);
    //ellipse(0, 0, 2*rad, 2*rad);
    stroke(rhcpColors[i], 20);
    strokeWeight(3);
    
    int bsize = out[i].bufferSize();
    
    for(int u = 0; u < bsize - 1; u += 10){ //called 103 times
      float x = (r)*cos(u*2*PI/bsize);
      float y = (r)*sin(u*2*PI/bsize);
      float x2 = (r + out[i].left.get(u)*100)*cos(u*2*PI/bsize);
      float y2 = (r + out[i].left.get(u)*100)*sin(u*2*PI/bsize);
     
      line(x,y,x2,y2);
      
      songData += out[i].left.get(u) + "/"; //projector data
    }
    beginShape();
    noFill();
    stroke(rhcpColors[i], 20);
    for(int y = 0; y < bsize; y+= 30){ //called 35 times
      float x3 = (r + out[i].left.get(y)*100)*cos(y*2*PI/bsize);
      float y3 = (r + out[i].left.get(y)*100)*sin(y*2*PI/bsize);
      vertex(x3,y3);
      pushStyle();
      stroke(rhcpColors[i]);
      strokeWeight(2);
      point(x3,y3);
      popStyle();
    }
    endShape();
  }
  popMatrix();
  
  float songTime = rhcpPlayer[0].position()/1000f; //song time in seconds
  server.write(songData+"d"+songTime+"t");
  
  for(int i = 0; i < rhcpTracks.length; i++){
    gainKnob[i].Knob();
    delayKnob[i].Knob();
    vocoderKnob[i].Knob();
  }
  
  textSize(20);
  text("Drums 1", 405, 80); 
  text("Drums 2", 405, 210); 
  text("Drums 3", 405, 340); 
  text("Guitar", 405, 470); 
  text("Rhythm", 405, 600); 
  text("Vocals", 405, 730);
}

void mousePressed(){
  for(int i = 0; i < rhcpTracks.length; i++){
    if(gainKnob[i].switchSelection(mouseX, mouseY)){
      if(gainKnob[i].selected){
        gain[i].setValue(gainKnob[i].getValue()*100-50);
      }
      else{
        gain[i].setValue(0); 
      }
    }
    else if(delayKnob[i].switchSelection(mouseX, mouseY)){
      delayIsPatched[i] = !delayIsPatched[i];
      if(delayKnob[i].selected){
        if(vocoderIsPatched[i]){
          lowpass[i].unpatch(vocoder[i]);
          lowpass[i].patch(delay[i]).patch(vocoder[i].modulator);
          //lowpass[i].unpatch(bitcrush[i]);
          //lowpass[i].patch(delay[i]).patch(bitcrush[i]);
        }
        else{
          lowpass[i].unpatch(out[i]);
          lowpass[i].patch(delay[i]).patch(out[i]);
        }
      }
      else{
        if(vocoderIsPatched[i]){
          delay[i].unpatch(vocoder[i]);
          //delay[i].unpatch(bitcrush[i]);
          lowpass[i].unpatch(delay[i]);
          lowpass[i].patch(vocoder[i].modulator);
          //lowpass[i].patch(bitcrush[i]);
        }
        else{
          delay[i].unpatch(out[i]);
          lowpass[i].unpatch(delay[i]);
          lowpass[i].patch(out[i]);
        }
      }
    }
    else if(vocoderKnob[i].switchSelection(mouseX, mouseY)){
      vocoderIsPatched[i] = !vocoderIsPatched[i];
      if(vocoderKnob[i].selected){
        if(delayIsPatched[i]){
          delay[i].unpatch(out[i]);
          delay[i].patch(vocoder[i].modulator).patch(out[i]);
          //delay[i].patch(bitcrush[i]).patch(out[i]);
        }
        else{
          lowpass[i].unpatch(out[i]);
          lowpass[i].patch(vocoder[i].modulator).patch(out[i]);
          //lowpass[i].patch(bitcrush[i]).patch(out[i]);
        }
        wave[i].patch(vocoder[i]).patch(out[i]);
      }
      else{
        if(delayIsPatched[i]){
          vocoder[i].unpatch(out[i]);
          delay[i].unpatch(vocoder[i]);
          //bitcrush[i]vocoder[i].unpatch(out[i]);
          //delay[i].unpatch(bitcrush[i]vocoder[i]);
          delay[i].patch(out[i]);
        }
        else{
          vocoder[i].unpatch(out[i]);
          lowpass[i].unpatch(vocoder[i]);
          //bitcrush[i].unpatch(out[i]);
          //lowpass[i].unpatch(bitcrush[i]);
          lowpass[i].patch(out[i]);
        }
        vocoder[i].unpatch(out[i]);
        wave[i].unpatch(vocoder[i]);
      }
    }
  }
}

void mouseDragged(){
  for(int i = 0; i < rhcpTracks.length; i++){
    gainKnob[i].isMouseOnKnob(mouseX, mouseY);
    delayKnob[i].isMouseOnKnob(mouseX, mouseY);
    vocoderKnob[i].isMouseOnKnob(mouseX, mouseY);
    
    if(gainKnob[i].movable && gainKnob[i].selected){
      gain[i].setValue(gainKnob[i].getValue()*100-50);
    }
    else if(delayKnob[i].movable){
      delay[i].setDelAmp(delayKnob[i].getValue());
    }
    else if(vocoderKnob[i].movable){
      wave[i].setFrequency(vocoderKnob[i].getValue()*480+20);
    }
  }
}

void mouseReleased(){
  for(int i = 0; i < rhcpTracks.length; i++){
    gainKnob[i].movable = false;
    delayKnob[i].movable = false;
    vocoderKnob[i].movable = false;
  }
}
