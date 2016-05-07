import java.io.FilenameFilter;

class SongSelect extends Scene{
  PApplet sketchReference;
  int selectedSong = 0;
  ArrayList<SongData> songList = new ArrayList<SongData>(); //This list holds all of the song objects
  String[] artistNames;
  String[] songNames;
                        
  PImage bg;
  PImage bgOverlay;
  PImage logo = loadImage("logo.png");
  Movie musicVideo;
  boolean playingVideo;
  
  String[] zoneNames = {"AlbumCircle","RightTriangle", "LeftTriangle", "ExitButton", "JamButton"};
  Zone aC, rT, lT, eB, jB;
                     
  SongSelect(PApplet pa_){
    sketchReference = pa_;
    aC = new Zone(zoneNames[0],round(width/4), round(height/4), round(width/2), round(height/2));
    rT = new Zone(zoneNames[1],round(width*0.05),round(height/2-50),round(width*0.05),100);
    lT = new Zone(zoneNames[2],round(width*0.90),round(height/2-50),round(width*0.05),100);
    eB = new Zone(zoneNames[3],round(width/2 - 212), round(height * 0.83), 180, 80);
    jB = new Zone(zoneNames[4],round(width/2 + 28), round(height * 0.83), 180, 80);
        
    SMT.add(aC);
    SMT.add(rT);
    SMT.add(lT);
    SMT.add(eB);
    SMT.add(jB);
  }
                        
  // Overriding init(), acting as setup()
  void init(){
    super.init();
    bg = loadImage("purpleGradient.png");
    bgOverlay = loadImage("shadowOverlay.png");
    
    File audioDirectory = new File(sketchPath("") + "audio");
    String[] songDirectories = audioDirectory.list(new FilenameFilter(){ //get all files from audio directory minus .DS_Store
      public boolean accept(File dir, String name){
          return !name.equals(".DS_Store");
      }
    });
    songNames = songDirectories.clone();
    artistNames = songDirectories.clone();
    for(int i = 0; i < songDirectories.length; i++){
      artistNames[i] = songDirectories[i].split("-")[0];
      songNames[i] = songDirectories[i].split("-")[1];
    }
  
    for(int i = 0; i < songNames.length; i++){
      songList.add(new SongData(artistNames[i], songNames[i]));
    }
    positionSongs();
    
    songList.get(0).selected = true;
  }
  
    void resetZones(){
      for(int i = 0; i < zoneNames.length; i++){
        SMT.get(zoneNames[i]).setTouchable(true);
        SMT.get(zoneNames[i]).setPickable(true);
      }
    }
  
    //Position and scale all of the songs
    void positionSongs(){
      for(float i = songList.size()-1; i > -1; i--){
        if (i == selectedSong){  //This is the currently selected song
          musicVideo = new Movie(sketchReference, songList.get((int)i).musicVideo);
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
  
    // Background texture
    image(bg, 0, 0, width, height);
    
    pushStyle();
    textAlign(CENTER);
    if (playingVideo){
      pushStyle();
      fill(#F7FF3A);
      textSize(50);      
      text(songList.get(selectedSong).title.toUpperCase(), width/2, height/8);
      popStyle();
      
      pushStyle();
      fill(#FFFFFF);
      textSize(20);
      text(songList.get(selectedSong).artist.toUpperCase(), width/2, height/8 + 40);
      popStyle();

      image(musicVideo, width/4, height/4, width/2, height/2);
      
      pushStyle();
      noFill();
      stroke(#FFFFFF);
      strokeWeight(3);
      rect(width/2 - 212, height * 0.83, 180, 80);
      rect(width/2 + 28, height * 0.83, 180, 80);
      popStyle();
      
      pushStyle();
      fill(#FFFFFF);
      textSize(30);
      noStroke();
      text("BACK", width/2 - 120, height * 0.84 + 41);
      text("JAM OUT", width/2 + 120, height * 0.84 + 41);
      popStyle();
      
    } else {
      for(int i = 0; i < selectedSong; i++){
          songList.get(i).drawSong();
      }
      for(int i = songList.size()-1; i >= selectedSong; i--){
          songList.get(i).drawSong();
      }

      pushStyle();
      fill(#FF2E87);
      noStroke();
      image(bgOverlay, 0, 0, width, height);
      triangle(width*0.1, height/2-50, width*0.1, height/2+50, width*0.05, height/2);
      triangle(width*0.9, height/2-50, width*0.9, height/2+50, width*0.95, height/2);
      popStyle();
     
      pushStyle();
      fill(#FFFFFF);
      textSize(30);
      text("SELECT A SONG", width/2, height/10);
      popStyle();
      
      image(logo, width/2 - 40, height/10, 80, 80);
      
      pushStyle();
      fill(#F7FF3A);
      textSize(50);      
      text(songList.get(selectedSong).title.toUpperCase(), width/2, height*0.9);
      popStyle();
      
      pushStyle();
      fill(#FFFFFF);
      textSize(20);
      text(songList.get(selectedSong).artist.toUpperCase(), width/2, height*0.9 + 40);
      popStyle();
    }
    popStyle();
  }
  
  //Overriding mousePressed()

  
  void handlePress(float x_, float y_){
    super.handlePress();
    handleExitButtonPress(x_, y_);
    handleJamButtonPress(x_, y_);
    handleAlbumCirclePress(x_, y_);
    handleLeftArrowPress();
    handleRightArrowPress();
  }
  
    void handleExitButtonPress(float x_, float y_){
    if(playingVideo){
      if(x_ > width/2 - 212 && x_ < width/2 - 32 && y_ > height * 0.83 && y_ < height * 0.83 + 80){
        playingVideo = false;
        musicVideo.stop();
      }
    } 
  }
  
  void handleJamButtonPress(float x_, float y_){
    if(playingVideo){
      if(x_ > width/2 + 28 && x_ < width/2 + 208 && y_ > height * 0.83 && y_ < height * 0.83 + 80){
        active = false;
        playingVideo = false;
        musicVideo.stop();
        
        File songDirectory = new File(sketchPath("") + "audio/" + songList.get(selectedSong).artist + "-" + songList.get(selectedSong).title);
        String[] songTracks = songDirectory.list(new FilenameFilter(){ //get all files from song directory minus .DS_Store
          public boolean accept(File dir, String name){
              return !name.equals(".DS_Store");
          }
        });
        
        
        TransitionIn.active = true;
        TransitionIn.init();
        mainInterfaceScene = new MainInterface(height/3, songTracks);
        
        audioControl = new AudioControl(songList.get(selectedSong).artist, songList.get(selectedSong).title, songTracks);
        audioControl.init();
        
        for(int i = 0; i < zoneNames.length; i++){
          SMT.get(zoneNames[i]).setTouchable(false);
          SMT.get(zoneNames[i]).setPickable(false);
        } 
      }
    }
  }
  
  void handleAlbumCirclePress(float x_, float y_){
    if(!playingVideo){
      if(dist(x_, y_, width/2, height/2) < 250){
          playingVideo = true;
          musicVideo.loop();
          musicVideo.jump(20);
      }
    }
  }
  
  void handleLeftArrowPress(){
    if(!playingVideo){
      songList.get(selectedSong).selected = false;
      selectedSong++;
      
      if(selectedSong > songNames.length-1){
        selectedSong = 0;
      }
      songList.get(selectedSong).selected = true;
      positionSongs();
    }
  }
  
  void handleRightArrowPress(){
    if(!playingVideo){
      songList.get(selectedSong).selected = false;
      selectedSong--;
     
      if(selectedSong < 0){
        selectedSong = songNames.length-1;
      }
      songList.get(selectedSong).selected = true;
      positionSongs();
    }
  }
  

}
