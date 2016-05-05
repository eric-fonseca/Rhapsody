class Visualizer{
  int r;
  color[] randomColors = new color[audioControl.audioTracks.length];
  String artistName;
  AudioOutput out[];
  
  
  Visualizer(AudioOutput[] output) {
    out = output;
    for(int i = 0; i < audioControl.audioTracks.length; i++){
      randomColors[i] = color(random(256), random(256), random(256));
    }
    artistName = audioControl.artist;
  }
  
  void update(){
    songData = "";
    pushMatrix();
    
    fill(#1A1F18, 20);
    noStroke();
    rect(0,0,width,height);
    translate(width/2, height/2);
    
    for(int i = 0; i < audioControl.audioTracks.length; i++){
      r = i * 20 + 200;
      
      noFill();
      fill(randomColors[i], 10);
      stroke(randomColors[i], 20);
      strokeWeight(10);
      
      int bsize = out[i].bufferSize();
      
      for(int u = 0; u < bsize - 1; u += 10){
        float x = (r)*cos(u*2*PI/bsize);
        float y = (r)*sin(u*2*PI/bsize);
        float x2 = (r + out[i].left.get(u)*100)*cos(u*2*PI/bsize);
        float y2 = (r + out[i].left.get(u)*100)*sin(u*2*PI/bsize);
       
        line(x,y,x2,y2);
        
        songData += out[i].left.get(u) + "/"; //projector data
      }
      /*beginShape();
      noFill();
      stroke(randomColors[i], 20);
      for(int y = 0; y < bsize; y+= 30){
        float x3 = (r + out[i].left.get(y)*100)*cos(y*2*PI/bsize);
        float y3 = (r + out[i].left.get(y)*100)*sin(y*2*PI/bsize);
        vertex(x3,y3);
        pushStyle();
        stroke(randomColors[i]);
        strokeWeight(2);
        point(x3,y3);
        popStyle();
      }
      endShape();*/
    }
    popMatrix();
    
    float songTime = audioControl.audioPlayer[0].position()/1000f; //song time in seconds
    server.write(songData+"@"+artistName+"*"+songTime+"~");
    
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
