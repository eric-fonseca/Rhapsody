
class Transition extends Scene{
  PApplet sketchReference;
  Movie m;
  boolean isOut;
  long startT;
  
  Transition(PApplet sr_, String m_, boolean b_){
    sketchReference = sr_;
    m = new Movie(sketchReference, m_);
    isOut = b_;
  }
  
  void init(){
    m.play();
    m.noLoop();
    startT = System.currentTimeMillis();
  }
  
  void update(){
    clear();
    
    if((System.currentTimeMillis() - startT)/1000 > m.duration()){
      println("notyeah");
      if(isOut){
        transitionOut();
      } else {
        transitionIn();
      }
    } else {
      image(m,0,0,width,height);
    }
  }
  
  void transitionOut(){
    m.stop();
    songSelectScene.active = true;
    songSelectScene.resetZones();
    this.active = false;
  }
  
  void transitionIn(){
    m.stop();
    mainInterfaceScene.active = true;
    this.active = false;
  }
  
  void movieEvent(Movie m_){
    m_.read(); 
  }
}
