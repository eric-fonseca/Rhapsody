import spacebrew.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Spacebrew spacebrewConnection;
String server="rhapsody-rit.herokuapp.com";
String name="Rhapsody Processing";
String description ="Web To Processing";
int port = 80;

Minim minim;
AudioOutput out;


String[] rhcpTracks = {"drums1", "drums2", "drums3", "guitar", "rhythm", "vocals"};
FilePlayer[] rhcp = new FilePlayer[rhcpTracks.length];
Gain[] gain = new Gain[rhcpTracks.length];

void setup() {
  size(1280,720);
  
  minim = new Minim(this);
  out = minim.getLineOut();
  
  for(int i = 0; i < rhcp.length; i++){
    rhcp[i] = new FilePlayer(minim.loadFileStream("audio/" + rhcpTracks[i] + ".mp3"));
    gain[i] = new Gain(0);
  }
  
  //CREATE SPACEBREW
  spacebrewConnection = new Spacebrew(this);
  
  //ADD PUBLISH/SUBSCRIBE
  for(int i = 0; i < rhcp.length; i++){
    spacebrewConnection.addSubscribe(rhcpTracks[i] + "Gain", "range");
  }
  spacebrewConnection.addSubscribe("playButton", "boolean");
  
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
    if(name.equals(rhcpTracks[i] + "Gain")){
      gain[i].setValue(value);
    }
  }
}

void onBooleanMessage( String name, boolean value ){
  println("got bool message " + name + " : " + value); 
  if(name.equals("playButton") && value == true){
    for(int i = 0; i < rhcp.length; i++){
      rhcp[i].rewind();
      rhcp[i].play();
      rhcp[i].patch(gain[i]).patch(out);
    }
  }
}