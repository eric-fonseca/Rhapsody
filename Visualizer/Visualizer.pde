import processing.net.*;
import processing.video.*;

Client client;
Movie musicVideo;

String messageFromServer = "";
String songData = "";
float[] visualizerData;
boolean dataReceived = false;
boolean newSong = true;
int r = 200;
int numTracks;
boolean videoPlaying = false;
String artistName = "";

int timeWithoutData = 0;
color[][] colorValues = {
                  {#FF2E87},
                  {#FF2E87, #F7FF3A},
                  {#FF2E87, #FB9760, #F7FF3A},
                  {#FF2E87, #FD6C70, #F9C151, #F7FF3A},
                  {#FF2E87, #FD5877, #FB9761, #F9D54A, #F7FF3A},
                  {#FF2E87, #FE4E7B, #FC7D6A, #FAB157, #F8DF46, #F7FF3A}
};
color[] trackColors;
PImage logo = loadImage(System.getProperty("user.home") + "/Desktop/Rhapsody/data/logo.png");

void setup() {
  size(1940, 1240);
  background(#000000);
  
  // Delete the dashes before the following two lines of code to full screen.

  //frame.removeNotify();
  //frame.setUndecorated(true);
  
  // Create the Client, connect to server at 127.0.0.1 (localhost), port 5204
  client = new Client(this, "127.0.0.1", 5204);
}

void draw() {
  //we know there is a message from the Server when there are greater than zero bytes available.
  if (client.available() > 0) {
    messageFromServer = client.readString();
    
    songData += messageFromServer;
    
    if(messageFromServer.indexOf("~") != -1){ //checks if a full chunk of data is received, "~" is always the last character
      dataReceived = true;
      visualizerData = float(songData.substring(0, songData.indexOf("@")).split("/")); //split the data into an array of floats
      numTracks = floor(visualizerData.length/103);
      
      if(newSong){
        println("Starting music video");
        
        trackColors = colorValues[numTracks - 1];
        
        artistName = songData.substring(songData.lastIndexOf("@") + 1, songData.lastIndexOf("*"));
        musicVideo = new Movie(this, System.getProperty("user.home") + "/Desktop/Rhapsody/data/" + artistName + ".mp4"); //music videos should be placed in the data directory
        musicVideo.play();
        musicVideo.volume(0);
        
        long currentTime = Long.parseLong(songData.substring(songData.lastIndexOf("*") + 1, songData.lastIndexOf("%")), 10);
        float timeDiff = (float)(System.currentTimeMillis() - currentTime) / 1000f;
        float songTime = float(songData.substring(songData.lastIndexOf("%") + 1, songData.lastIndexOf("~")));
        
        musicVideo.jump(songTime + timeDiff); //sync up music video with audio tracks
        newSong = false;
      }
      songData = songData.substring(songData.lastIndexOf("~") + 1); //keep trailing data
    }
    
    timeWithoutData = 0;
  }
  else{
    dataReceived = false;
    
    if(timeWithoutData > 10){
      background(#000000);
      image(logo, width/2 -400, height/2 -400, 800, 800);
      newSong = true;
    }
    timeWithoutData++;
  }
  
  if(dataReceived){
    pushMatrix();
    image(musicVideo, width/2 - 400, height/2 - 300, 800, 600);
    stroke(#000000); //must match background color
    strokeWeight(1000);
    ellipse(width/2, height/2, 1600, 1600);
  
    noStroke();
    translate(width/2, height/2);
     for(int i = 0; i < numTracks; i++){
        r = i * 50 + 350;
        
        noFill();
        fill(trackColors[i]);
        stroke(trackColors[i]);
        strokeWeight(10);
        
        for(int u = 0; u < 1023; u += 10){ //called 103 times
          if(visualizerData.length > u/10+i*103){
            float x = (r)*cos(u*2*PI/1024);
            float y = (r)*sin(u*2*PI/1024);
            float x2 = (r + visualizerData[u/10+i*103]*100)*cos(u*2*PI/1024);
            float y2 = (r + visualizerData[u/10+i*103]*100)*sin(u*2*PI/1024);
            
            line(x,y,x2,y2);
          }
        }
        beginShape();
        noFill();
        stroke(trackColors[i], 60);
        for(int y = 0; y < 1024; y+= 30){ //called 35 times
          if(visualizerData.length > y/10+i*103){
            float x3 = (r + visualizerData[y/10+i*103]*100)*cos(y*2*PI/1024);
            float y3 = (r + visualizerData[y/10+i*103]*100)*sin(y*2*PI/1024);
            vertex(x3,y3);
            pushStyle();
            stroke(trackColors[i]);
            strokeWeight(2);
            point(x3,y3);
            popStyle();
          }
        }
        endShape();
      }
      popMatrix();
   }
}

void movieEvent(Movie m) {
  m.read();
}
