
class SongSelect extends Scene{
  PApplet sketchReference;
  int selectedSong = 0;
  ArrayList<SongData> songList = new ArrayList<SongData>(); //This list holds all of the song objects
  String[] songNames = {"The Beatles - Hello Goodbye", 
                        "ACDC - Thunderstruck", 
                        "Metallica - Enter Sandman", 
                        "Michael Jackson - Smooth Criminal", 
                        "The Beatles - Hello Goodbye", 
                        "ACDC - Thunderstruck", 
                        "Metallica - Enter Sandman", 
                        "Michael Jackson - Smooth Criminal"};
                        
  PImage bg;
  Movie musicVideo;
  boolean playingVideo;
                     
  // This class is for the most part preset, so a constructor can be basic.   
  SongSelect(PApplet pa_){
    sketchReference = pa_;
  }
                        
  // Overriding init(), acting as setup()
  void init(){
    super.init();
    bg = loadImage("background.jpg");
  
    for(int i = 0; i < songNames.length; i++){
      songList.add(new SongData(songNames[i]));
    }
    positionSongs();
    
    songList.get(0).selected = true;
    
    textSize(30);
    textAlign(CENTER);
    strokeWeight(3);
  }
  
    //Position and scale all of the songs
    void positionSongs(){
      for(float i = songList.size()-1; i > -1; i--){
        if (i == selectedSong){  //This is the currently selected song
          musicVideo = new Movie(sketchReference,  songList.get((int)i).musicVideo);
          songList.get((int)i).setPos(width/2,height/2);
          songList.get((int)i).setSize(500);
        }
        else{  //scale unselected songs
          songList.get((int)i).setPos((width/2)+(i-selectedSong)*175,height/2);
          songList.get((int)i).setSize(300);
        }
      }
    }
  
  // Overriding update(), acting as draw()
  void update(){
    super.update();
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
    } else {
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
  
  //Overriding mousePressed()
  void handleMousePress(float x_, float y_){
    super.handleMousePress();
    if(playingVideo){
      //back button
      if(x_ > width/2 - 182 && x_ < width/2 - 22 && y_ > height * 0.88 && y_ < height * 0.88 + 60){
        playingVideo = false;
        musicVideo.stop();
      }
      //jam out button
      else if(x_ > width/2 + 18 && x_ < width/2 + 178 && y_ > height * 0.88 && y_ < height * 0.88 + 60){
        active = false;
        playingVideo = false;
        musicVideo.stop();
        mainInterfaceScene = new MainInterface(height/3, 4);
        mainInterfaceScene.active = true;
      }
    } else {
      //current album
      if(dist(x_, y_, width/2, height/2) < 250){
        playingVideo = true;
        musicVideo.loop();
      }
      //left arrow
      else if(x_ > width*0.05 && x_ < width*0.1 && y_ > height/2-50 && y_ < height/2+50){
        songList.get(selectedSong).selected = false;
        selectedSong--;
       
        if(selectedSong < 0){
          selectedSong = songNames.length-1;
        }
        songList.get(selectedSong).selected = true;
        positionSongs();
      }
      //right arrow
      else if(x_ > width*0.9 && x_ < width*0.95 && y_ > height/2-50 && y_ < height/2+50){
        songList.get(selectedSong).selected = false;
        selectedSong++;
        
        if(selectedSong > songNames.length-1){
          selectedSong = 0;
        }
        songList.get(selectedSong).selected = true;
        positionSongs();
      }
    }
  }
}
