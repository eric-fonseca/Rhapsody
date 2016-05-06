class Visualizer{
  AudioOutput out[];
  String artistName;
  
  // References
  TrackControl[] controls;
  DotPathControl inner, outer;
  
  // Visualizer variables
  float sDeltaA, usDeltaA, usMinR, usMaxR;
  float fExpand, fRadius;
  float[] tExpand, tRadius;
  
  // constants
  final float opacity = 75;
  final int numMiniBars = 9; // make this an odd number
  final float barBoost = 2.5;
  final float barDecayRate = 0.75;
  final float barChangeRate = 6;
  final float selectedMaxBloom = 100;
  
  Visualizer(AudioOutput[] output) {
    out = output;
    artistName = audioControl.artist;
    controls = mainInterfaceScene.controls;
    inner = mainInterfaceScene.inner;
    outer = mainInterfaceScene.outer;
    init();
  }
  
  void init(){
    sDeltaA = PI*2/numMiniBars;
    usDeltaA = PI / audioControl.audioTracks.length;
    usMinR = inner.r;
    usMaxR = outer.r;
    tExpand = new float[audioControl.audioTracks.length];
    tRadius = new float[audioControl.audioTracks.length];
  }
  
  void update(){
    songData = "";
    pushStyle();
    fill(#FF2E87, opacity);
    noStroke();
    
    for(int i = 0; i < audioControl.audioTracks.length; i++){
      int bsize = out[i].bufferSize();
      float total = 0;
      for(int u = 0; u < bsize - 1; u += 10){
        total += out[i].left.get(u);
        songData += out[i].left.get(u) + "/"; //projector data
      }
      float mapped = map(total,-1,10,0,1);
      if(mainInterfaceScene.controls[i].selection){
        for(int y = 0; y < numMiniBars; y++){
          float sMinR = mainInterfaceScene.controls[i].r/2;
          fRadius = mapped*selectedMaxBloom;
          tRadius[i] += (fRadius - tRadius[i])/barChangeRate;
          float expand = sMinR+tRadius[i];
          pushMatrix();
          pushStyle();
          if(mainInterfaceScene.controls[i].getDirection() == "right"){
            fill(mainInterfaceScene.controls[i].cPrimary, opacity*2/3);
          } else {
            fill(mainInterfaceScene.controls[i].cSecondary, opacity*2/3);
          }
          
          translate(mainInterfaceScene.controls[i].x, mainInterfaceScene.controls[i].y);
          rotate(y*sDeltaA);
          ellipse(0,0,
                  mainInterfaceScene.controls[i].r/2 + expand,
                  mainInterfaceScene.controls[i].r/2 + expand);
          popStyle();
          popMatrix();
        }
      } else {
        int centerIndex = (numMiniBars - 1)/2;
        float miniDelta = usDeltaA/(numMiniBars + 1);
        fExpand = mapped*(usMaxR-usMinR);
        tExpand[i] += (fExpand - tExpand[i])/barChangeRate;
        for(int y = 0; y < numMiniBars; y++){
          int distCI = Math.abs(centerIndex - y);
          float angle1 = -usDeltaA + miniDelta * (y + 0.75) * 2; 
          float angle2 = angle1 + miniDelta;
          float expand = usMinR+tExpand[i]*pow(barDecayRate,distCI)*barBoost;
          
          pushMatrix();
          translate(width/2, height/2);
          rotate(controls[i].a);
          beginShape();
          vertex(cos(angle1)*usMinR,sin(angle1)*usMinR);
          vertex(cos(angle2)*usMinR,sin(angle2)*usMinR);
          vertex(cos(angle2)*expand,sin(angle2)*expand);
          vertex(cos(angle1)*expand,sin(angle1)*expand);
          endShape(CLOSE);
          popMatrix();
        }
      }
    }
    popStyle();
    
    float songTime = audioControl.audioPlayer[0].position()/1000f; //song time in seconds
    long currentTime = System.currentTimeMillis();
    server.write(songData+"@"+artistName+"*"+currentTime+"%"+songTime+"~");
    
    if(!audioControl.audioPlayer[0].isPlaying()){ //song is finished playing
      mainInterfaceScene.active = false;
      for(int i = 0; i < audioControl.audioPlayer.length; i++){
        audioControl.out[i].close();
      }
      minim.stop();
      songSelectScene.active = true;
    }
  }
}
