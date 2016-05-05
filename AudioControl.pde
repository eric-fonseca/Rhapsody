class AudioControl{
  String artist;
  String title;
  String[] audioTracks;
  FilePlayer[] audioPlayer;
  AudioOutput[] out;
  
  Gain[] gain;
  Delay[] delay;
  Vocoder[] vocoder;
  Oscil[] wave;
  MoogFilter[] highpass;
  MoogFilter[] lowpass;
  
  KnobControl[] gainKnob;
  KnobControl[] delayKnob;
  KnobControl[] vocoderKnob;
  DoubleBarControl[] frequencyRange;

  boolean[] delayIsPatched;
  boolean[] vocoderIsPatched;

  AudioControl(String artist_, String title_, String[] trackNames_) {
     artist = artist_;
     title = title_;
     audioTracks = trackNames_;
  }
  
  void init(){
     audioPlayer = new FilePlayer[audioTracks.length];
     out = new AudioOutput[audioTracks.length];
     
     gain = new Gain[audioTracks.length];
     delay = new Delay[audioTracks.length];
     vocoder = new Vocoder[audioTracks.length];
     wave = new Oscil[audioTracks.length];
     highpass = new MoogFilter[audioTracks.length];
     lowpass = new MoogFilter[audioTracks.length];
     
     gainKnob = new KnobControl[audioTracks.length];
     delayKnob = new KnobControl[audioTracks.length];
     vocoderKnob = new KnobControl[audioTracks.length];
     frequencyRange = new DoubleBarControl[audioTracks.length];
     
     delayIsPatched = new boolean[audioTracks.length];
     vocoderIsPatched = new boolean[audioTracks.length];
    
     for(int i = 0; i < audioTracks.length; i++){
        out[i] = minim.getLineOut();
        audioPlayer[i] = new FilePlayer(minim.loadFileStream("audio/" + artist + "-" + title + "/" + audioTracks[i], 1024, true));
        
        gain[i] = new Gain(0);
        delay[i] = new Delay(0.5f, 0.5f, true, true);
        vocoder[i] = new Vocoder(1024, 8);
        wave[i] = new Oscil(100, 0.8, Waves.SAW);
        highpass[i] = new MoogFilter(20, 0.5, MoogFilter.Type.HP);
        lowpass[i] = new MoogFilter(20000, 0.5, MoogFilter.Type.LP);
        
        gainKnob[i] = mainInterfaceScene.controls[i].knobs[0];
        delayKnob[i] = mainInterfaceScene.controls[i].knobs[1];
        vocoderKnob[i] = mainInterfaceScene.controls[i].knobs[2];
        frequencyRange[i] = mainInterfaceScene.controls[i].doubleBar;
        
        delayIsPatched[i] = false;
        vocoderIsPatched[i] = false;
     }
     
     for(int i = 0; i < audioTracks.length; i++){
        audioPlayer[i].rewind();
        audioPlayer[i].play();
        audioPlayer[i].patch(gain[i]).patch(highpass[i]).patch(lowpass[i]).patch(out[i]);
     }
     
     visualizer = new Visualizer(out);
  }
  
  void handlePress(){
    for(int i = 0; i < audioTracks.length; i++){
      if(gainKnob[i].centerPressed){
        if(gainKnob[i].selection){
          gain[i].setValue(gainKnob[i].getValue()*100-50);
        }
        else{
          gain[i].setValue(0); 
        }
      }
      else if(delayKnob[i].centerPressed){
        delayIsPatched[i] = !delayIsPatched[i];
        if(delayKnob[i].selection){
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
      else if(vocoderKnob[i].centerPressed){
        vocoderIsPatched[i] = !vocoderIsPatched[i];
        if(vocoderKnob[i].selection){
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
    }
  }
  
  void handleDrag(){
    for(int i = 0; i < audioTracks.length; i++){
      if(gainKnob[i].movable && gainKnob[i].selection){
        gain[i].setValue(gainKnob[i].getValue()*100-50);
      }
      else if(delayKnob[i].movable){
        delay[i].setDelAmp(delayKnob[i].getValue());
      }
      else if(vocoderKnob[i].movable){
        wave[i].setFrequency(vocoderKnob[i].getValue()*480+20);
      }
      else if(frequencyRange[i].pressed){
        //convert frequency values to [20,20000] range
        if(frequencyRange[i].orientRight){
          highpass[i].frequency.setLastValue((frequencyRange[i].value2 + frequencyRange[i].h) * -19980 / (frequencyRange[i].h * 2) + 20000);
          lowpass[i].frequency.setLastValue((frequencyRange[i].value1 + frequencyRange[i].h) * -19980 / (frequencyRange[i].h * 2) + 20000);
        }
        else{
          highpass[i].frequency.setLastValue((frequencyRange[i].value1 + frequencyRange[i].h) * 19980 / (frequencyRange[i].h * 2) + 20);
          lowpass[i].frequency.setLastValue((frequencyRange[i].value2 + frequencyRange[i].h) * 19980 / (frequencyRange[i].h * 2) + 20);
        }
      }
    }
  }
}
