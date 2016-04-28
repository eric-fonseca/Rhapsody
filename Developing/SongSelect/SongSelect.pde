import processing.video.*;

ArrayList<Song> songList = new ArrayList<Song>(); //This list holds all of the song objects
int selectedSong = 0;
PImage bg;
Movie musicVideo;
boolean playingVideo;
String[] songNames = {"The Beatles - Hello Goodbye", "ACDC - Thunderstruck", "Metallica - Enter Sandman", "Michael Jackson - Smooth Criminal", "The Beatles - Hello Goodbye", "ACDC - Thunderstruck", "Metallica - Enter Sandman", "Michael Jackson - Smooth Criminal"};

void setup(){  //Instantiate and place the song objects
  size(1280, 800);
  bg = loadImage("background.jpg");

  for(int i = 0; i < songNames.length; i++){
    songList.add(new Song(songNames[i]));
  }
  positionSongs();
  
  songList.get(0).selected = true;
  
  textSize(30);
  textAlign(CENTER);
  strokeWeight(3);
}

void positionSongs(){  //Position and scale all of the songs
  for(float i = songList.size()-1; i > -1; i--){
    if (i == selectedSong){  //This is the currently selected song
      musicVideo = new Movie(this,  songList.get((int)i).musicVideo);
      songList.get((int)i).setPos(width/2,height/2);
      songList.get((int)i).setSize(500);
    }
    else{  //scale unselected songs
      songList.get((int)i).setPos((width/2)+(i-selectedSong)*175,height/2);
      songList.get((int)i).setSize(300);
    }
  }
}

void draw(){
  clear();
  
  image(bg, 0, 0, width, height);
  text("SELECT A SONG", width/2, height/10);
  
  if (playingVideo){
    image(musicVideo, width/6, height/6, width/1.5, height/1.5);
    noFill();
    stroke(#FFFFFF);
    rect(width/2 - 182, height * 0.88, 160, 60);
    rect(width/2 + 18, height * 0.88, 160, 60);
    text("BACK", width/2 - 100, height * 0.88 + 41);
    text("JAM OUT", width/2 + 100, height * 0.88 + 41);
  }
  else{
    for(int i = 0; i < selectedSong; i++){
        songList.get(i).drawSong();
    }
    for(int i = songList.size()-1; i >= selectedSong; i--){
        songList.get(i).drawSong();
    }
    stroke(#000000);
    fill(#FFFFFF);
    triangle(width*0.1, height/2-50, width*0.1, height/2+50, width*0.05, height/2);
    triangle(width*0.9, height/2-50, width*0.9, height/2+50, width*0.95, height/2);
    text(songList.get(selectedSong).name, width/2, height*0.9);
  }
}

void mousePressed(){
   if(playingVideo){
      //back button
      if(mouseX > width/2 - 182 && mouseX < width/2 - 22 && mouseY > height * 0.88 && mouseY < height * 0.88 + 60){
        playingVideo = false;
        musicVideo.stop();
      }
      
      //jam out button
      else if(mouseX > width/2 + 18 && mouseX < width/2 + 178 && mouseY > height * 0.88 && mouseY < height * 0.88 + 60){
        println("jam out pressed"); //go to next screen
      }
   }
   else{
     //current album
     if(dist(mouseX, mouseY, width/2, height/2) < 250){
       playingVideo = true;
       musicVideo.loop();
     }
     
     //left arrow
     else if(mouseX > width*0.05 && mouseX < width*0.1 && mouseY > height/2-50 && mouseY < height/2+50){
       songList.get(selectedSong).selected = false;
       selectedSong--;
       
       if (selectedSong < 0){
         selectedSong = songNames.length-1;
       }
       songList.get(selectedSong).selected = true;
       positionSongs();
     }
     
     //right arrow
     else if(mouseX > width*0.9 && mouseX < width*0.95 && mouseY > height/2-50 && mouseY < height/2+50){
       songList.get(selectedSong).selected = false;
       selectedSong++;
        
       if (selectedSong > songNames.length-1){
         selectedSong = 0;
       }
       songList.get(selectedSong).selected = true;
       positionSongs();
     }
   }
}
  
void movieEvent(Movie m) {
  m.read();
}
