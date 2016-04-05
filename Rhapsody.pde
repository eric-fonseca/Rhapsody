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
int[] rhcpColors = {#FD756D, #FD756D, #FD756D, #F7FF3A, #FF2E87, #FABA54};
FilePlayer[] rhcpPlayer = new FilePlayer[rhcpTracks.length];

Gain[] gain = new Gain[rhcpTracks.length];
Delay[] delay = new Delay[rhcpTracks.length];
boolean[] delayIsPatched = new boolean[rhcpTracks.length];

Flanger[] flanger = new Flanger[rhcpTracks.length];

MoogFilter[] highpass = new MoogFilter[rhcpTracks.length];
MoogFilter[] lowpass = new MoogFilter[rhcpTracks.length];

Vocoder[] vocoder = new Vocoder[rhcpTracks.length];
boolean[] vocoderIsPatched = new boolean[rhcpTracks.length];
Oscil[] wave = new Oscil[rhcpTracks.length];

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
    vocoderIsPatched[i] = false;
    wave[i] = new Oscil(100, 0.8, Waves.SAW);
    
    cp5.addToggle(rhcpTracks[i] + " Delay", false, 60, i*75+50, 30, 10)
                  .setLabel("Delay Off")
                  .setMode(ControlP5.SWITCH);
                  
    cp5.addToggle(rhcpTracks[i] + " Vocoder", false, 60, i*75+80, 30, 10)
                  .setLabel("Vocoder Off")
                  .setMode(ControlP5.SWITCH);
                  
    cp5.addSlider(rhcpTracks[i] + " Gain", -50, 50, 140, i*75+50, 180, 10)
                  .setLabel("Gain")
                  .setValue(0.0);
                  
    cp5.addSlider(rhcpTracks[i] + " Delay Amp", 0.0, 1.0, 140, i*75+65, 180, 10)
                  .setLabel("Delay Amp")
                  .setValue(0.5);
                  
    cp5.addSlider(rhcpTracks[i] + " Vocoder Freq", 20, 1000, 140, i*75+80, 180, 10)
                  .setLabel("Vocoder Freq")
                  .setValue(100);
                  
    cp5.addRange(rhcpTracks[i] + " Filter", 20, 20000, 140, i*75+95, 180, 15)
                  .setLabel("Filter Frequencies");
  }
  
  //separate loop so all tracks can load first
  for(int i = 0; i < rhcpPlayer.length; i++){
    rhcpPlayer[i].rewind();
    rhcpPlayer[i].play();
    rhcpPlayer[i].patch(gain[i]).patch(highpass[i]).patch(lowpass[i]).patch(out[i]);
  }
}

void controlEvent(ControlEvent controlEvent) {
  for(int i = 0; i < rhcpTracks.length; i++){
    if(controlEvent.isFrom(rhcpTracks[i] + " Delay")){
      delayIsPatched[i] = !delayIsPatched[i];
      if(controlEvent.value() == 1){
        controlEvent.getController().setLabel("Delay on");
        
        if(vocoderIsPatched[i]){
          lowpass[i].unpatch(vocoder[i]);
          lowpass[i].patch(delay[i]).patch(vocoder[i].modulator);
        }
        else{
          lowpass[i].unpatch(out[i]);
          lowpass[i].patch(delay[i]).patch(out[i]);
        }
      }
      else{
        controlEvent.getController().setLabel("Delay off");
        
        if(vocoderIsPatched[i]){
          delay[i].unpatch(vocoder[i]);
          lowpass[i].unpatch(delay[i]);
          lowpass[i].patch(vocoder[i].modulator);
        }
        else{
          delay[i].unpatch(out[i]);
          lowpass[i].unpatch(delay[i]);
          lowpass[i].patch(out[i]);
        }
      }
    }
    else if(controlEvent.isFrom(rhcpTracks[i] + " Vocoder")){
      vocoderIsPatched[i] = !vocoderIsPatched[i];
      if(controlEvent.value() == 1){
        controlEvent.getController().setLabel("Vocoder on");
        
        if(delayIsPatched[i]){
          delay[i].unpatch(out[i]);
          delay[i].patch(vocoder[i].modulator).patch(out[i]);
        }
        else{
          lowpass[i].unpatch(out[i]);
          lowpass[i].patch(vocoder[i].modulator).patch(out[i]);
        }
        wave[i].patch(vocoder[i]).patch(out[i]);
        
      }
      else{
        controlEvent.getController().setLabel("Vocoder off");
        
        if(delayIsPatched[i]){
          vocoder[i].unpatch(out[i]);
          delay[i].unpatch(vocoder[i]);
          delay[i].patch(out[i]);
        }
        else{
          vocoder[i].unpatch(out[i]);
          lowpass[i].unpatch(vocoder[i]);
          lowpass[i].patch(out[i]);
        }
        vocoder[i].unpatch(out[i]);
        wave[i].unpatch(vocoder[i]);
        
      }
    }
    else if(controlEvent.isFrom(rhcpTracks[i] + " Delay Amp")){
      delay[i].setDelAmp(controlEvent.value());
    }
    else if(controlEvent.isFrom(rhcpTracks[i] + " Gain")){
      gain[i].setValue(controlEvent.value());
    }
    else if(controlEvent.isFrom(rhcpTracks[i] + " Vocoder Freq")){
      wave[i].setFrequency(controlEvent.value());
    }
    else if(controlEvent.isFrom(rhcpTracks[i] + " Filter")){
      highpass[i].frequency.setLastValue(controlEvent.getController().getArrayValue(0));
      lowpass[i].frequency.setLastValue(controlEvent.getController().getArrayValue(1));
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
    //ellipse(0, 0, 2*rad, 2*rad);
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
