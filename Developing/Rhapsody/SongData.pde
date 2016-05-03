class SongData{

  float xpos;
  float ypos;
  float targetxpos;
  float targetypos;
  float size = 15;
  float targetsize;
  color Color;
  
  PGraphics mask;
  PImage img;
  PImage imgBW;
  PImage imgCO;
  PImage glow = loadImage("knobGlow2.png");
  
  public String musicVideo;
  String name;
  String artist;
  String title;

  boolean hide;
  boolean selected = false;

  SongData(String artist_, String title_) {
       artist = artist_;
       title = title_;
       imgBW = loadImage(artist_ + "_BlackAndWhite.png");
       imgCO = loadImage(artist_ + "_Color.png");
       musicVideo = artist_ + ".mp4";
  }
  
  void drawSong() {
    if (!hide){
      xpos = lerp(xpos, targetxpos, 0.15f);
      ypos = lerp(ypos, targetypos, 0.15f);
      size = lerp(size, targetsize, 0.15f);
      
        if(selected){
        image(glow,xpos-size*.725,ypos-size*.725,size*1.45,size*1.45);
        image(imgCO,xpos-size/2,ypos-size/2,size,size);
      }else{
        image(imgBW,xpos-size/2,ypos-size/2,size,size);
      }
    }
  }
  
  public void setPos(float x, float y){
    targetxpos = x;
    targetypos = y;
  }
  
  public void setSize(float s){
    targetsize = s;
  }
  
  public void setHidden(boolean state){
    hide = state;
  }
}
