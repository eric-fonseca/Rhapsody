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
  PImage glow = loadImage("knobGlow.png");
  public String musicVideo;
  String name;

  boolean hide;
  boolean selected = false;

  SongData(String title) {
     name = title;
     img = loadImage(title + ".png");
     musicVideo = title + ".mp4";
  }
  
  void drawSong() {
    if (!hide){
      xpos = lerp(xpos, targetxpos, 0.05f);
      ypos = lerp(ypos, targetypos, 0.05f);
      size = lerp(size, targetsize, 0.05f);
      
      if(selected) image(glow,xpos-size*.725,ypos-size*.725,size*1.45,size*1.45);
      image(img,xpos-size/2,ypos-size/2,size,size);
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
