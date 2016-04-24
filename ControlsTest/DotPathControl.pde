// The dotted circular line which rotates as a visual effect
class DotPathControl extends Control{
  float dr;
  color dcolor;
  int numDots;
  float orientation, direction, rate, increasedRate;
  float angleBetween;
  
  DotPathControl(float x_, float y_, float r_, float dr_, color dc_, int nd_, float dir_, float irr_){
    super(x_, y_, r_);
    dr = dr_;
    dcolor = dc_;
    numDots = nd_;
    orientation = 0;
    direction = dir_;
    rate = direction;
    increasedRate = irr_;
  }
  
  void drawDotPath(){
    angleBetween = 2 * PI / numDots;
    if(selection){
      rate = direction * -increasedRate;
    } else {
      rate = direction;
    }
    
    orientation += rate;
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
      ellipse(0, r, dr, dr);
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

