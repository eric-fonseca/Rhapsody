import processing.net.*;
import processing.video.*;

Client client;
Movie musicVideo;

String messageFromServer = "";
String songData = "";
float[] visualizerData;
boolean dataReceived = false;
color trackColor = #FFFFFF;
int r = 200;

void setup() {
  size(800, 800);
  
  // Create the Client, connect to server at 127.0.0.1 (localhost), port 5204
  client = new Client(this, "127.0.0.1", 5204);
  
  musicVideo = new Movie(this, "RHCPsnow.mp4"); //music videos should be placed in the data directory
  musicVideo.play();
}

void draw() {
  pushMatrix();
  
  fill(#1A1F18, 20);
  noStroke();
  rect(0,0,width,height);
  translate(width/2, height/2);
  
  //we know there is a message from the Server when there are greater than zero bytes available.
  if (client.available() > 0) {
    messageFromServer = client.readString();
    
    songData += messageFromServer;
    
    if(messageFromServer.indexOf("x") != -1){ //checks if all data is received, "x" is always the last character
      dataReceived = true;
      songData = songData.substring(0, songData.indexOf("x")); //remove the "x" at the end of the data
      visualizerData = float(songData.split("/"));
      //println(visualizerData.length);
      songData = "";
    }
  }
  
  if(dataReceived){
     for(int i = 0; i < 6; i++){
        switch(i){
          //Drums
          case 0:
          case 1:
          case 2:
            trackColor = #FD756D;
            r = 175;
            break;
          // Lead-Guitar
          case 3:
            trackColor = #F7FF3A;
            r = 275;
            break;
          // Rhythm-Guitar
          case 4:
            trackColor = #FF2E87;
            r = 125;
            break;
          // Vocals
          case 5:
            trackColor = #FABA54;
            r = 225;
            break;
        }
        
        noFill();
        fill(trackColor, 10);
        stroke(trackColor, 20);
        strokeWeight(3);
        
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
        stroke(trackColor, 20);
        for(int y = 0; y < 1024; y+= 30){ //called 35 times
          if(visualizerData.length > y/10+i*103){
            float x3 = (r + visualizerData[y/10+i*103]*100)*cos(y*2*PI/1024);
            float y3 = (r + visualizerData[y/10+i*103]*100)*sin(y*2*PI/1024);
            vertex(x3,y3);
            pushStyle();
            stroke(trackColor);
            strokeWeight(2);
            point(x3,y3);
            popStyle();
          }
        }
        endShape();
      }
   }
   
   popMatrix();
   image(musicVideo, 0, 0, 220, 165);
}

void movieEvent(Movie m) {
  m.read();
}
