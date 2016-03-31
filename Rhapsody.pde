import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import controlP5.*;

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
int[] rhcpColors = {#AA3333, #AA3333, #AA3333, #66AA66, #6666AA, #FF2E87};
FilePlayer[] rhcpPlayer = new FilePlayer[rhcpTracks.length];
Gain[] gain = new Gain[rhcpTracks.length];
Delay[] delay = new Delay[rhcpTracks.length];
Flanger[] flanger = new Flanger[rhcpTracks.length];

/*MoogFilter[] moog = new MoogFilter[rhcpTracks.length];
MoogFilter[] moog2 = new MoogFilter[rhcpTracks.length];*/

HighPassSP[] highpass = new HighPassSP[rhcpTracks.length];
LowPassSP[] lowpass = new LowPassSP[rhcpTracks.length];

AudioOutput[] out = new AudioOutput[rhcpTracks.length];

int r = 200;
float rad = 70;

void setup() {
  size(1280,720);
  
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  
  for(int i = 0; i < rhcpPlayer.length; i++){
    out[i] = minim.getLineOut();
    
    rhcpPlayer[i] = new FilePlayer(minim.loadFileStream("audio/" + rhcpTracks[i] + ".mp3", 1024, true));
    
    gain[i] = new Gain(30);
    
    //Delay(float maxDelayTime, float amplitudeFactor, boolean feedBackOn, boolean passAudioOn)
    delay[i] = new Delay(0.5f, 0.5f, true, true);
    
    //delay[i].setDelAmp(1.0);
    
    //println(delay[i].delTime.getLastValue());
    
    flanger[i] = new Flanger( 1,      // delay length in milliseconds ( clamped to [0,100] )
                              0.2f,   // lfo rate in Hz ( clamped at low end to 0.001 )
                              1,      // delay depth in milliseconds ( minimum of 0 )
                              0.5f,   // amount of feedback ( clamped to [0,1] )
                              0.5f,   // amount of dry signal ( clamped to [0,1] )
                              0.5f    // amount of wet signal ( clamped to [0,1] )
    );
    
    //moog[i] = new MoogFilter(1200, 0.9, MoogFilter.Type.BP);
    
    /*moog2[i] = new MoogFilter(44000, 0.5);
    moog2[i].type = MoogFilter.Type.LP;*/
    
    highpass[i] = new HighPassSP(0, rhcpPlayer[i].sampleRate());
    lowpass[i] = new LowPassSP(44100, rhcpPlayer[i].sampleRate());
    
    cp5.addToggle(rhcpTracks[i] + " Delay", false, 50, i*55+50, 75, 20)
                  .setLabel(rhcpTracks[i] + " Delay Off")
                  .setMode(ControlP5.SWITCH);
                  
    cp5.addSlider(rhcpTracks[i] + " Gain", -50.0, 50.0, 140, i*55+50, 180, 10)
                  .setLabel("Gain")
                  .setValue(0.0);
                  
    cp5.addSlider(rhcpTracks[i] + " Delay Amp", 0.0, 1.0, 140, i*55+65, 180, 10)
                  .setLabel("Delay Amp")
                  .setValue(0.5);
  }
  
  //separate loop so all tracks can load first
  for(int i = 0; i < rhcpPlayer.length; i++){
    rhcpPlayer[i].rewind();
    rhcpPlayer[i].play();
    rhcpPlayer[i].patch(gain[i]).patch(highpass[i]).patch(lowpass[i]).patch(out[i]);
  }
  
  //rhcpPlayer[3].patch(gain[3]); //slows down track(?)
  //gain[3].patch(out[3]); //no difference
  //rhcpPlayer[3].patch(gain[3]).patch(out[3]); //overlays another track on top of old
}

void controlEvent(ControlEvent controlEvent) {
  for(int i = 0; i < rhcpTracks.length; i++){
    if(controlEvent.isFrom(rhcpTracks[i] + " Delay")){
      if(controlEvent.value() == 1){
        controlEvent.getController().setLabel(controlEvent.name() + " on");
        
        lowpass[i].unpatch(out[i]);
        lowpass[i].patch(delay[i]).patch(out[i]);
      }
      else{
        controlEvent.getController().setLabel(controlEvent.name() + " off");
        
        delay[i].unpatch(out[i]);
        lowpass[i].unpatch(delay[i]);
        lowpass[i].patch(out[i]);
      }
    }
    else if(controlEvent.isFrom(rhcpTracks[i] + " Delay Amp")){
      delay[i].setDelAmp(controlEvent.value());
    }
    else if(controlEvent.isFrom(rhcpTracks[i] + " Gain")){
      gain[i].setValue(controlEvent.value());
    }
  }
}

void draw() {
  pushMatrix();
  
  fill(#1A1F18, 20);
  noStroke();
  rect(0,0,width,height);
  translate(width*0.65, height/2);
  
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
    ellipse(0, 0, 2*rad, 2*rad);
    stroke(rhcpColors[i], 20);
    strokeWeight(3);
    
    int bsize = out[i].bufferSize();
    for(int u = 0; u < bsize - 1; u += 10){
      float x = (r)*cos(u*2*PI/bsize);
      float y = (r)*sin(u*2*PI/bsize);
      float x2 = (r + out[i].left.get(u)*100)*cos(u*2*PI/bsize);
      float y2 = (r + out[i].left.get(u)*100)*sin(u*2*PI/bsize);
      
      line(x,y,x2,y2);
    }
    beginShape();
    noFill();
    stroke(rhcpColors[i], 20);
    for(int y = 0; y < bsize; y+= 30){
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
}
