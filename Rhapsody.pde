import spacebrew.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

Spacebrew spacebrewConnection;
String server="rhapsody-rit.herokuapp.com";
String name="Rhapsody Processing";
String description ="Web To Processing";
int port = 80;

Minim minim;
AudioPlayer kick;

String[] rhcpTracks = {"drums1", "drums2", "drums3", "guitar", "rhythm", "vocals"};
AudioPlayer[] rhcp = new AudioPlayer[rhcpTracks.length];

void setup() {
  size(1280,720);
  
  minim = new Minim(this);
  
  for(int i = 0; i < rhcp.length; i++){
    rhcp[i] = minim.loadFile("audio/" + rhcpTracks[i] + ".mp3");
  }
  
  //kick = minim.loadFile("kick.mp3");
  
  //CREATE SPACEBREW
  spacebrewConnection = new Spacebrew(this);
  
  //ADD PUBLISH/SUBSCRIBE
  for(int i = 0; i < rhcp.length; i++){
    spacebrewConnection.addSubscribe(rhcpTracks[i], "range");
  }
  spacebrewConnection.addSubscribe("buttonPress", "boolean");
  
  //CONNECT SPACEBREW
  spacebrewConnection.connect(server, port, name, description);
}


void draw() {
  background(0);
  textSize(42);
  fill(255, 0, 255);
  text("Rhapsody Test", 100, 100);
}


void onRangeMessage( String name, int value ){
  println("got int message " + name + " : " + value);
  for(int i = 0; i < rhcp.length; i++){
    if(name.equals(rhcpTracks[i])){
      rhcp[i].setGain(value);
    }
  }
}

void onBooleanMessage( String name, boolean value ){
  println("got bool message " + name + " : " + value); 
  if (name.equals("buttonPress")){
    if (value == true) {
      for(int i = 0; i < rhcp.length; i++){
        rhcp[i].rewind();
        rhcp[i].play();
      }
    }
  } 
}
