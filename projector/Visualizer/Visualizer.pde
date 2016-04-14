import processing.net.*;

Client client;

String messageFromServer = "";
String songData = "";
String visualizerData = "";
String visualizerCopy = "";
boolean dataReceived = false;
color trackColor = #FFFFFF;

void setup() {
  size(800, 800);
  
  // Create the Client, connect to server at 127.0.0.1 (localhost), port 5204
  client = new Client(this, "127.0.0.1", 5204);
}

void draw() {
  fill(#1A1F18, 10);
  noStroke();
  rect(0,0,width,height);
  translate(width/2, height/2);
  
  //we know there is a message from the Server when there are greater than zero bytes available.
  if (client.available() > 0) {
    messageFromServer = client.readString();
    
    songData += messageFromServer;
    
    if(messageFromServer.indexOf("e") != -1){ //checks if all data is received, "e" is always the last character
      dataReceived = true;
      songData = songData.substring(0, songData.indexOf("e"));
      visualizerData = songData;
      
      songData = "";
    }
  }
  
  if(dataReceived){
     visualizerCopy = visualizerData;
     for(int i = 0; i < 6; i++){
        switch(i){
          //Drums
          case 0:
          case 1:
          case 2:
            trackColor = #FD756D;
            break;
          // Lead-Guitar
          case 3:
            trackColor = #F7FF3A;
            break;
          // Rhythm-Guitar
          case 4:
            trackColor = #FF2E87;
            break;
          // Vocals
          case 5:
            trackColor = #FABA54;
            break;
        }
        
        noFill();
        fill(trackColor, 10);
        stroke(trackColor, 20);
        strokeWeight(3);
        
        for(int j = 0; j < 1023; j += 10){ //called 103 times
          Float x = null;
          Float y = null;
          Float x2 = null;
          Float y2 = null;
        
          if(visualizerData.indexOf("a") != -1){
            x = float(visualizerData.substring(0, visualizerData.indexOf("a")));
            visualizerData = visualizerData.substring(visualizerData.indexOf("a") + 1);
          }
          if(visualizerData.indexOf("b") != -1){
            y = float(visualizerData.substring(0, visualizerData.indexOf("b")));
            visualizerData = visualizerData.substring(visualizerData.indexOf("b") + 1);
          }
          if(visualizerData.indexOf("c") != -1){
            x2 = float(visualizerData.substring(0, visualizerData.indexOf("c")));
            visualizerData = visualizerData.substring(visualizerData.indexOf("c") + 1);
          }
          if(visualizerData.indexOf("d") != -1){
            y2 = float(visualizerData.substring(0, visualizerData.indexOf("d")));
            visualizerData = visualizerData.substring(visualizerData.indexOf("d") + 1);
          }
          
          if(x != null && y != null && x2 != null && y2 != null){
            line(x, y, x2, y2);
          }
        }
        beginShape();
        noFill();
        stroke(trackColor, 20);
        for(int k = 0; k < 1024; k+= 30){ //called 35 times
          Float x3 = null;
          Float y3 = null;
        
          if(visualizerData.indexOf("x") != -1){
            x3 = float(visualizerData.substring(0, visualizerData.indexOf("x")));
            visualizerData = visualizerData.substring(visualizerData.indexOf("x") + 1);
          }
          if(visualizerData.indexOf("y") != -1){
            y3 = float(visualizerData.substring(0, visualizerData.indexOf("y")));
            visualizerData = visualizerData.substring(visualizerData.indexOf("y") + 1);
          }
        
          if(x3 != null && y3 != null){
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
      visualizerData = visualizerCopy;
   }
}
