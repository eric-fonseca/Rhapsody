// Merging Point for all UI components, handles intra-control behaviors
class MainInterface{
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float CenterControlRatio = 0.5; // Relative radius ratio of the colored circle within the center of the class
  final float outerRingRatio = 1.0; // Relative radius ratio of the outer dot path
  final float outerRingRotate = -0.0010; // The speed of which the outer dot path rotates
  final float innerRingRatio = 0.5; // Relative radius ratio of the inner dot path
  final float innerRingRotate = 0.0015; // Relative radius ratio of the inner dot path
  
  CenterControl centerCircle;
  DotPathControl outer, inner;
  TrackControl[] controls;
  
  float x, y, r; // x-value, y-value, class wide radius
  int nc; // number of controls
  int cri, cli; // current right index, current left index
  boolean rsc, lsc; // right selection check, left selection check

  MainInterface(float x_, float y_, float r_, int nc_){
    x = x_; // x value of the center of the class
    y = y_; // y value of the center of the class
    r = r_; // radius value for the class
    nc = nc_; // Number of controls for the class
    controls = new TrackControl[nc];
    
    // Creating classes
    centerCircle = new CenterControl(x,y,r*CenterControlRatio, 8, color(247, 255, 58), color(255,46,135));
    outer = new DotPathControl(x,y,r*outerRingRatio,5,color(255, 202), 30, outerRingRotate);
    inner = new DotPathControl(x,y,r*innerRingRatio,5,color(255, 202), 20, innerRingRotate);
    for(int i = 0; i < nc; i++){
      float temp = 2 * PI / nc;
      TrackControl c = new TrackControl(x,y,r,i * temp - PI,inner,outer,centerCircle,5,color(247, 255, 58),color(255,46,135));
      controls[i] = c;
    }
  }
  
  // This function draws all of the classes, built intending it to be ran every frame. Call within Draw()
  void drawAll(){
    outer.drawDotPath(); 
    inner.drawDotPath();
    centerCircle.drawCenterControl();
    
    splitControls();
    
    for(int i = 0; i < nc; i++){
      limitSelections(controls[i], i);
      controls[i].update();
      controls[i].drawTrackControl();
      controls[i].drawControlKnobs();
      controls[i].drawEchoes();
    }
    
    if(!rsc){
      cri = -1;
    }
    
    if(!lsc){
      cli = -1;
    }
  }
  
    // This function causes there to only allow one control be to selected on each side at a given moment.
    void limitSelections(TrackControl c, int i){
      if(controls[i].selection == true){
        if(c.getDirection() == "right"){
          if(cri != -1){
            if(i != cri){
              c.selection = false; // refuse to select
              controls[cri].addEcho();
            } 
            rsc = true;
          } else { // cri does not have index
            cri = i;
            rsc = true;
          }
        }
        
        if(c.getDirection() == "left"){
          if(cli != -1){
            if(i != cli){
              c.selection = false; // refuse to select
              controls[cli].addEcho();
            }
            lsc = true;
          } else { // cli does not have index
            cli = i;
            lsc = true;
          }
        }
      } else { // Current control is not selected, check if users unselected cri/cli
        if(cri == i){
          cri = -1; 
        }
        if(cli == i){
          cli = -1;
        }
      }
    }
  
    // This function causes Controls that drift too close together to move apart from each other autonomously
    // This fixes the issue if controls become difficult to select individually if they stack on top of each other.
    void splitControls(){
      
      // Constant used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
      final float minAngleDifference = PI/6; // If differnce of two controls are within this range function gets called
      final float repellingForce = PI/11; // The amount that controls get pushed away from each other. Should be more than the half of minAngleDifference
      
      for(int i = 0; i < nc; i++){
        for(int u = i; u < nc; u++){
          if(u == i){
            continue;
          }
          
          // Note that function only runs if both controls are in an unselected state
          if(controls[i].selection == false && controls[u].selection == false){
            boolean a1B = false; 
            boolean a2B = false;
            TrackControl c1 = controls[i];
            TrackControl c2 = controls[u];
            float a1 = c1.a + PI;
            float a2 = c2.a + PI;
            if(Math.abs(Math.abs(a1) - Math.abs(a2)) < minAngleDifference){
              if(a1 > a2){
                pushControls(a1,c1,repellingForce);
                pushControls(a2,c2,-repellingForce);
              } else {
                pushControls(a1,c1,-repellingForce);
                pushControls(a2,c2,repellingForce);
              }
            }
          }
        }
      }
    }
    
      // This function is only called in SplitControls() as an utility function
      void pushControls(float a, TrackControl c, float t){
        a = a + t - PI;
        if(t > 0 && a > PI){
          a -= 2 * PI;
        }
        if(t < 0 && a < -PI){
         a += 2 * PI; 
        }
        c.a = a;
      }
  
  // Function to relay mousePress data to controls. Call within mousePressed();
  void passMousePress(float x_, float y_){ 
    for(int i = 0; i < nc; i++){
      controls[i].passMousePress(x_,y_);
    }
    centerCircle.detectPress(x_,y_);
  }
  
  // Function to relay mouseDrag data to controls. Call within mouseDragged();
  void passMouseDrag(float x_, float y_){
    for(int i = 0; i < nc; i++){
      controls[i].passMouseDrag(x_,y_);
    }
    centerCircle.detectDrag(x_,y_);
  }
  
  // Function to relay mouseRelease data to controls. Call within mouseReleased();
  void passMouseRelease(){
    for(int i = 0; i < nc; i++){
      controls[i].passMouseRelease();
    }
    centerCircle.detectRelease();
    outer.dragPause(false);
    inner.dragPause(false);
  }
}
