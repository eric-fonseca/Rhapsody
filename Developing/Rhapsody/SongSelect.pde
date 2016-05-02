
class SongSelect extends Scene{
  PApplet sketchReference;
  int selectedSong = 0;
  ArrayList<SongData> songList = new ArrayList<SongData>(); //This list holds all of the song objects
  String[] artistNames = {"The Killers","The Rolling Stones","Weezer","The Beatles","Queen","Ok Go","Nirvana"};
  String[] songNames = {"Mr. Brightside","Paint it Black","Say it Aint So","Hello Goodbye","Somebody to Love","Here it Goes Again","Come As You Are"};           
                        
  PImage bg;
  PImage bgOverlay;
  PImage logo = loadImage("data/logo.png");
  Movie musicVideo;
  boolean playingVideo;
                     
  // This class is for the most part preset, so a constructor can be basic.   
  SongSelect(PApplet pa_){
    sketchReference = pa_;
  }
                        
  // Overriding init(), acting as setup()
  void init(){
    super.init();
    bg = loadImage("background.png");
    bgOverlay = loadImage("shadowOverlay.png");
  
    for(int i = 0; i < songNames.length; i++){
      songList.add(new SongData(artistNames[i],songNames[i]));
    }
    positionSongs();
    
    songList.get(0).selected = true;
    
    textSize(30);
    textAlign(CENTER);
  }
  
    //Position and scale all of the songs
    void positionSongs(){
      for(float i = songList.size()-1; i > -1; i--){
        if (i == selectedSong){  //This is the currently selected song
          musicVideo = new Movie(sketchReference,  songList.get((int)i).musicVideo);
          songList.get((int)i).setPos(width/2,height/2);
          songList.get((int)i).setSize(550);
        }
        else{  //scale unselected songs
          songList.get((int)i).setPos((width/2)+(i-selectedSong)*220,height/2);
          songList.get((int)i).setSize(400);
        }
      }
    }
  
  // Overriding update(), acting as draw()
  void update(){
    super.update();
    clear();
  
    image(bg, 0, 0, width, height);
    
    if (playingVideo){
      fill(#F7FF3A);
      textSize(50);      
      text(songList.get(selectedSong).song.toUpperCase(), width/2, height/8);
      textSize(20);
      fill(#FFFFFF);
      text(songList.get(selectedSong).artist.toUpperCase(), width/2, height/8 + 40);
      image(musicVideo, width/4, height/4, width/2, height/2);
      noFill();
      stroke(#FFFFFF);
      textSize(30);
      strokeWeight(3);
      rect(width/2 - 212, height * 0.83, 180, 80);
      rect(width/2 + 28, height * 0.83, 180, 80);
      text("BACK", width/2 - 120, height * 0.84 + 41);
      text("JAM OUT", width/2 + 120, height * 0.84 + 41);
    } else {
      for(int i = 0; i < selectedSong; i++){
          songList.get(i).drawSong();
      }
      for(int i = songList.size()-1; i >= selectedSong; i--){
          songList.get(i).drawSong();
      }
      //stroke(#000000);
      fill(#FF2E87);
      noStroke();
      image(bgOverlay, 0, 0, width, height);
      triangle(width*0.1, height/2-50, width*0.1, height/2+50, width*0.05, height/2);
      triangle(width*0.9, height/2-50, width*0.9, height/2+50, width*0.95, height/2);
     
      
      //triangle(width*0.32, height*0.9-30, width*0.32, height*0.9+30, width*0.29, height*0.9);
      //triangle(width*0.67, height*0.9-30, width*0.67, height*0.9+30, width*0.70, height*0.9);
      fill(#FFFFFF);
      textSize(30);
      text("SELECT A SONG", width/2, height/10);
      image(logo, width/2- 40, height/10, height/10, height/10);
      fill(#F7FF3A);
      
      textSize(50);      
      text(songList.get(selectedSong).song.toUpperCase(), width/2, height*0.9);
      textSize(20);
      fill(#FFFFFF);
      text(songList.get(selectedSong).artist.toUpperCase(), width/2, height*0.9 + 40);

    }
  }
  
  //Overriding mousePressed()
  void handlePress(float x_, float y_){
    super.handlePress();
    if(playingVideo){
      //back button
      if(x_ > width/2 - 212 && x_ < width/2 - 32 && y_ > height * 0.83 && y_ < height * 0.83 + 80){
        playingVideo = false;
        musicVideo.stop();
      }
      //jam out button
       else if(x_ > width/2 + 28 && x_ < width/2 + 208 && y_ > height * 0.83 && y_ < height * 0.83 + 80){
        active = false;
        playingVideo = false;
        musicVideo.stop();
        mainInterfaceScene = new MainInterface(height/3, 5);
        mainInterfaceScene.active = true;
      }
    } else {
      //current album
      if(dist(x_, y_, width/2, height/2) < 250){
        playingVideo = true;
        musicVideo.loop();
      }
      //left arrow
      else if(mouseX > width*0.05 && mouseX < width*0.1 && mouseY > height/2-50 && mouseY < height/2+50){
        songList.get(selectedSong).selected = false;
        selectedSong--;
       
        if(selectedSong < 0){
          selectedSong = songNames.length-1;
        }
        songList.get(selectedSong).selected = true;
        positionSongs();
      }
      //right arrow
       else if(mouseX > width*0.9 && mouseX < width*0.95 && mouseY > height/2-50 && mouseY < height/2+50){
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
