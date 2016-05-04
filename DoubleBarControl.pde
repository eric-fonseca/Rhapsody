// Double bar control for the user to change filter frequencies
class DoubleBarControl extends Control{
  float h;
  float value1, value2;
  color cPrimary;
  boolean orientRight = true;
  TrackControl parent;
  String zoneName;
  Zone zone;
  
  // Animation variables
  float th, tr, tsw;
  float tv1, tv2;
  
  final color unpressedbackgroundColor = #202020;
  final color pressedbackgroundColor = #404040;
  final color unselectedSpaceColor = #C8C8C8;
  final float hitboxSpread = 2.0;
  
  // Animation constants
  final float animationFrames = 15;
  final float phase0Cutoff = 5;
  final float phase1Cutoff = 1;
  final float phase2Cutoff = 2;
  
  DoubleBarControl(float x_, float y_, float sw_, color c_, float h_,TrackControl tc_, String zn_){
    super(x_,y_,0,sw_,3);
    h = h_;
    sw = sw_;
    cPrimary = c_;
    value1 = -h;
    value2 = h;
    tv1 = 0;
    tv2 = 0;
    parent = tc_;
    zoneName = zn_;
    zone = new Zone(zoneName,round(x-sw*hitboxSpread),round(y-h-sw*hitboxSpread*2),round(sw*hitboxSpread*2),round(h*2+sw*hitboxSpread*4));
    SMT.add(zone);
  }
  
    void setNewPosition(float x_, float y_){
      x = x_;
      y = y_;
    }
    
    void setColorValues(color pri){
      cPrimary = pri;
    }
    
    void flipValues(){
      float temp = value1;
      if(orientRight){
        value1 = -value2;
        value2 = -temp;
        orientRight = false;
      } else {
        value1 = -value2;
        value2 = -temp;
        orientRight = true;
      }
    }
  
  void update(){
    super.update();

    // Updating zone properties
    SMT.get(zoneName).setX(round(x-sw*hitboxSpread));
    SMT.get(zoneName).setY(round(y-h-sw*hitboxSpread*2));
    SMT.get(zoneName).setWidth(round(sw*hitboxSpread*2));
    SMT.get(zoneName).setHeight(round(h*2+sw*hitboxSpread*4));
    
  }

  void animate(){
    super.animate();
    if(animating){
      if(!phaseSwitch && !phases[0] && !phases[1] && !phases[2]){
        phaseSwitch = true;
        phases[0] = true; 
      } else if(phases[0]){
        if(phaseSwitch){
          th = 0;
          tv1 = map(value1, -h, h, -th, th);
          tv2 = map(value2, -h, h, -th, th);
          phaseSwitch = false;
        }
        
        th += (h - th)/animationFrames;
        drawBar(th,tv1,tv2);
        
        if(h - th < phase0Cutoff){
          phaseSwitch = true;
          phases[0] = false;
          phases[1] = true;
        }
      } else if(phases[1]){
        if(phaseSwitch){
          tr = 0;
          phaseSwitch = false;
        }
        
        tr += (sw*2 - tr)/(animationFrames/2);
        drawBar(h,value1,value2);
        drawCircles(tr);
        
        if(sw*2 - tr < phase1Cutoff){
          phaseSwitch = true;
          phases[1] = false;
          phases[2] = true;
          Echo c1 = new Echo(x,y+value1,sw*2,5,10,sw,color(255));
          c1.start = true;
          echoes.add(c1);
          
          Echo c2 = new Echo(x,y+value2,sw*2,5,10,sw,color(255));
          c2.start = true;
          echoes.add(c2);
        }
      } else if(phases[2]){
        if(phaseSwitch){
          tsw = 0;
          phaseSwitch = false;
        }
        
        tsw += (sw*hitboxSpread*2 - tsw)/animationFrames;
        drawBackground(tsw);
        drawBar(h,value1,value2);
        drawCircles(sw*2);
        
        if(sw*hitboxSpread*2 - tsw < phase2Cutoff){
          phaseSwitch = false;
          animating = false;
          phases[2] = false;
        }
      }
    } else {
      drawBackground(sw*hitboxSpread*2);
      drawBar(h,value1,value2);
      drawCircles(sw*2);
    }
    drawEchoes();
  }
  
    void drawBackground(float sw_){
      pushMatrix();
      translate(x,y);
      if(pressed){
        stroke(pressedbackgroundColor);
      } else {
        stroke(unpressedbackgroundColor);
      }
      strokeWeight(sw_);
      strokeCap(ROUND);
      line(0,-h-sw*hitboxSpread,0,h+sw*hitboxSpread);
      popMatrix();
    }
    
    void drawBar(float h_, float v1_, float v2_){
      pushMatrix();
      translate(x,y);
      stroke(unselectedSpaceColor);
      strokeWeight(sw);
      strokeCap(ROUND);
      line(0,-h_,0,v1_);
      popMatrix();
      
      pushMatrix();
      translate(x,y);
      stroke(cPrimary);
      strokeWeight(sw);
      strokeCap(ROUND);
      line(0,v1_,0,v2_);
      popMatrix();
      
      pushMatrix();
      translate(x,y);
      stroke(unselectedSpaceColor);
      strokeWeight(sw);
      strokeCap(ROUND);
      line(0,v2_,0,h_);
      popMatrix();
    }
    
    void drawCircles(float sw_){
      pushMatrix();
      translate(x,y);
      noStroke();
      fill(255);
      ellipse(0,value1,sw_,sw_);
      popMatrix(); 
      
      pushMatrix();
      translate(x,y);
      noStroke();
      fill(255);
      ellipse(0,value2,sw_,sw_);
      popMatrix(); 
    }
  
  void detectPress(float x_, float y_){
    if(!parent.selection){
       return; 
    }
    
    // rectangular detection
    if(x_ > x - sw*hitboxSpread && 
       x_ < x + sw*hitboxSpread &&
       y_ > y-h-sw*hitboxSpread &&
       y_ < y+h+sw*hitboxSpread){
      pressed = true;
    } else {
      pressed = false; 
    }
  }
  
  void detectDrag(float x_, float y_){
    if(!parent.selection){
       return; 
    }
    
    if(pressed){
      if (dist(x_,y_,x,y + value1) < sw*hitboxSpread*2){
        if(y_ > y - h && y_ < y + h && y_ < y + value2){
          value1 = y_ - height/2;
        }
      } else if (dist(x_,y_,x, y + value2) < sw*hitboxSpread*2){
        if(y_ > y - h && y_ < y + h && y_ > y + value1){
          value2 = y_ - height/2;
        }
      }
    }
  }
  
  void detectRelease(){
    pressed = false; 
  }
}
