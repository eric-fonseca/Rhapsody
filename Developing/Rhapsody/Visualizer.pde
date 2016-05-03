class Visualizer{
  int r;
  color[] randomColors = new color[audioControl.audioTracks.length];
  AudioOutput out[];
  
  Visualizer(AudioOutput[] output) {
    out = output;
    for(int i = 0; i < audioControl.audioTracks.length; i++){
      randomColors[i] = color(random(256), random(256), random(256));
    }
  }
  
  void update(){
    fill(#1A1F18, 20);
    noStroke();
    rect(0,0,width,height);
    translate(width/2, height/2);
    
    for(int i = 0; i < audioControl.audioTracks.length; i++){
      r = i * 40 + 200;
      
      noFill();
      fill(randomColors[i], 10);
      stroke(randomColors[i], 20);
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
      endShape();
    }
  }
}
