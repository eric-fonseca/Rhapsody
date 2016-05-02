// The dotted circular line which rotates as a visual effect
class DotPathControl extends Control{
  int numDots;
  float angleBetween, orientation, direction, rate, increasedRate;
  color dcolor;
  
  // Animation variables
  float dr, t1r, t2r, t3r;
  
  // Animation constants
  final float animationStrokeWidth = 2.5;
  final float animationCutoff = 10;
  final float frameLengthForT1 = 30;
  final float frameLengthForT2 = 40;
  final float frameLengthForT3 = 15;
  final float phase0_SecondEllipseRatio = 1;
  final float phase0_OpacityDecay = 5;
  
  DotPathControl(float x_, float y_, float r_, int nd_, float dir_, float irr_, float dr_, color dc_){
    super(x_, y_, r_, 0, 2);
    numDots = nd_;
    angleBetween = 2 * PI / numDots;
    orientation = 0;
    direction = dir_;
    rate = direction;
    increasedRate = irr_;
    dcolor = dc_;
    
    t1r = 0;
    t2r = 0;
    t3r = 0;
    dr = dr_;
  }
  
  void update(){
    super.update();
    if(selection){
      rate = direction * -increasedRate;
    } else {
      rate = direction;
    }
    orientation += rate;
    this.drawControl(r);
  }

  void animate(){
    super.animate();
    if(animating){
      if(!phaseSwitch && !phases[0] && !phases[1]){
        phaseSwitch = true;
        phases[0] = true; 
      }
      if(phases[0]){
        if(phaseSwitch && !phases[1]){
          Echo ce1 = new Echo(x,y,0,animationStrokeWidth,dcolor);
          ce1.start = true;
          echoes.add(ce1);
          
          Echo ce2 = new Echo(x,y,0,animationStrokeWidth,dcolor);
          ce2.start = true;
          echoes.add(ce2);
          
          phaseSwitch = false; 
        }
        
        t1r += (r*2 - t1r) / frameLengthForT1;
        t2r += (r*(2 + phase0_SecondEllipseRatio) - t2r) / frameLengthForT2;
        
        echoes.get(0).dynamicUpdate(phase0_OpacityDecay, t2r);
        echoes.get(1).dynamicUpdate(phase0_OpacityDecay, t1r);
        
        if((r*2 - t1r) < r*2/3){
          phases[1] = true;
          phaseSwitch = true;
        }
        
        if((r*2 - t1r) < animationCutoff){
          phases[0] = false;
          echoes = new ArrayList<Echo>();
        }
      }
      if(phases[1]){
        if(phaseSwitch){
          phaseSwitch = false; 
        }
        
        t3r += (r - t3r) / frameLengthForT3;
        
        if((r - t3r) < animationCutoff){
          phases[1] = false;
          phaseSwitch = false;
          animating = false;
        }
        
        this.drawControl(t3r);
      }
    } else {
      update();
    } 
  }
    
  void drawControl(float r_){
    super.drawControl();
    for(int i = 1; i <= numDots; i++){
      float tempAngle = angleBetween * i - PI + orientation;
      if(tempAngle < -PI){
        tempAngle += 2*PI; 
      } else if(tempAngle > PI){
        tempAngle -= 2*PI; 
      }
      pushMatrix();
      translate(x,y);
      rotate(tempAngle);
      noStroke();
      fill(dcolor);
      ellipse(0, r_, dr, dr);
      popMatrix();
    }
  }
  
  void dragPause(boolean b_){
    if(b_){
      rate = 0; 
    } else {
      rate = direction; 
    }
  }
}

