// Merging Point for all UI components, handles intra-control behaviors
class MainInterface extends Scene{
  float x, y, r; // x-value, y-value, class wide radius
  int nc; // number of controls
  int cri, cli; // current right index, current left index
  boolean rsc, lsc; // right selection check, left selection check
  String[] tracks;
  
  CenterControl centerCircle;
  DotPathControl outer, inner;
  TrackControl[] controls;
  
  // Constants used to safely & quickly change aspects of the program, to act as an interface for Team Designers/Developers
  final float CenterControlRatio = 0.5; // Relative radius ratio of the colored circle within the center of the class
  final float outerRingRatio = 1.0; // Relative radius ratio of the outer dot path
  final float outerRingRotate = -0.0010; // The speed of which the outer dot path rotates
  final float innerRingRatio = 0.5; // Relative radius ratio of the inner dot path
  final float innerRingRotate = 0.0015; // Relative radius ratio of the inner dot path
  final float increasedRotateRatio = 10; // The increased speed of rotation when center control is selected

  MainInterface(float r_, String[] tracks_){
    x = width/2; // x value of the center of the class
    y = height/2; // y value of the center of the class
    r = r_; // radius value for the class
    tracks = tracks_; //track names to load images
    nc = tracks_.length; // Number of controls for the class
    init();
  }
  
  // Overriding init(), acting as setup()
  void init(){
    super.init();
    
    // Creating classes
    centerCircle = new CenterControl(x,y,r*CenterControlRatio,8,#FF2E87);
    centerCircle.animating = true;
    
    outer = new DotPathControl(x,y,r*outerRingRatio,30,outerRingRotate,increasedRotateRatio,5,color(255, 202));
    outer.animating = true;
    
    inner = new DotPathControl(x,y,r*innerRingRatio,20,innerRingRotate,increasedRotateRatio,5,color(255, 202));
   
    controls = new TrackControl[nc];
    float temp = 2 * PI / nc;
    for(int i = 0; i < nc; i++){
      TrackControl c = new TrackControl(x,y,r,5,i * temp - PI,increasedRotateRatio,inner,outer,centerCircle,color(247, 255, 58),#5B23AE,zoneNames[i]);
      
      if(tracks[i].equals("bass.mp3")){
        c.setIcon(loadImage("GUITAR.png"));
      }
      else if(tracks[i].equals("drums.mp3")){
        c.setIcon(loadImage("DRUMS.png"));
      }
      else if(tracks[i].equals("guitar.mp3")){
        c.setIcon(loadImage("GUITAR-ELECTRIC.png"));
      }
      else if(tracks[i].equals("vocals.mp3")){
        c.setIcon(loadImage("VOCALS.png"));
      }
      else if(tracks[i].equals("synth.mp3")){
        c.setIcon(loadImage("SYNTH.png")); //replace with new image
      }
      else if(tracks[i].equals("keyboard.mp3")){
        c.setIcon(loadImage("PIANO.png"));
      }
      else if(tracks[i].equals("strings.mp3")){
        c.setIcon(loadImage("STRINGS.png")); //replace with new image
      }
      else if(tracks[i].equals("misc.mp3")){
        c.setIcon(loadImage("MISC.png")); //replace with new image
      }
      
      c.animating = true;
      controls[i] = c;
    }
  }
  
  // Overriding update(), acting as draw()
  // This function draws all of the classes, built intending it to be ran every frame. Call within Draw()
  void update(){
    super.update();
    clear();
    
    visualizer.update();
    
    outer.animate();
    if(outer.phases[1]){
      centerCircle.isDrawingIn = true;
      centerCircle.animate();
    } else if(centerCircle.isDrawingIn){
      centerCircle.animate();
    }
    
    splitControls();
    
    if(centerCircle.isDrawingOut){
      for(int i = 0; i < nc; i++){
        limitSelections(controls[i], i);
        controls[i].update();
        controls[i].animate();
        controls[i].drawInnerControls();
        controls[i].drawEchoes();
      }
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
  void handlePress(float x_, float y_){ 
    super.handlePress();
    centerCircle.detectPress(x_,y_,centerCircle.r/2);
    outer.selection = centerCircle.selection;
  }
  
  // Function to relay mouseDrag data to controls. Call within mouseDragged();
  void handleDrag(float x_, float y_){
    super.handleDrag();
    if(centerCircle.pressed){
      centerCircle.detectDrag(x_,y_,centerCircle.r/2);
    }
  }
  
  // Function to relay mouseRelease data to controls. Call within mouseReleased();
  void handleRelease(){
    super.handleRelease();
    centerCircle.detectRelease();
    outer.selection = false;
    outer.dragPause(false);
    inner.dragPause(false);
  }
}
