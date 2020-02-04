class Vesica {
 
  float x, y;    // center position of entire construction
  float r;       // radius of circles
  float theta;   // rotation
  
  float d;       // distance between two circles
  float dd;      // destination distance
  
  color myc;     // intersection area fill color
  
  float[] dots;  // size of the dot
  float[] dotr;  // rotation of the dot
  float[] dote;  // extension distance of the dot
  int maxdots;
  int numdots;
  
  char ch;
  char subch;
  
  boolean mother = false;
  
  Vesica(float _x, float _y, float _r, float _theta) {
    x = _x;
    y = _y;
    r = _r;
    theta = _theta;
    
    d = r;
    
    myc = somecolor();
    
    // dots are random ornamental ellipses around each circle
    maxdots = round(random(r*.2));
    numdots = maxdots;
    dots = new float[maxdots];  // size of dot
    dotr = new float[maxdots];  // rotation of dot in radians
    dote = new float[maxdots];  // extension of dot from circle radius
    
    // randomize starting angle
    float td = random(TWO_PI);
    for (int n=0;n<numdots;n++) {
      dots[n] = 1 - 1*log(random(1.0));    // natural log to size the dots
      dotr[n] = td;
      dote[n] = random(-r*.4,r*.1);
      if (dote[n]<0) dote[n] = 0;    // truncate negative extensions
      td+=atan(r/4);      // increment placement angle so dots line up in a row
    }
    
    // primary character label
    ch = ' ';
    if (random(100)<30) ch = char(floor(random(65,91)));       // capital letters
    
    // sub character label
    subch = ' ';
    if (random(100)<22) subch = char(floor(random(65,91)));    // capital letters
    if (random(100)<66) subch = char(floor(random(40,64)));    // special characters and numbers
    
    render();
  }

  void render() {
    pushMatrix();
    translate(x,y);
    rotate(theta);
    
    // twin circles shadow
    noFill();
    blendMode(BLEND);
    stroke(myc,32);
    ellipse(-d/2+1,1,r*2,r*2);
    ellipse(d/2+1,1,r*2,r*2);
    blendMode(SCREEN);
    // twin circles
    stroke(255,28);
    ellipse(-d/2,0,r*2,r*2);
    ellipse(d/2,0,r*2,r*2);
    
    // line between centerpoints
    blendMode(BLEND);
    stroke(0,22);
    line(-d/2+1,1,d/2+1,1);
    blendMode(SCREEN);
    stroke(255,32);
    line(-d/2,0,d/2,0);

    // vesicant
    float dh = d/2;
    float omega = 2*asin(dh/r);
    stroke(255,128);
    fill(myc,16);
    beginShape();
    arcShape(-d/2,0,r,r,-omega,omega);
    arcShape(d/2,0,r,r,PI-omega,PI+omega);
    endShape();
    
    // centerpoint ellipses
    float pr = 5 - 2*log(random(1.0));
    noStroke();
    fill(255,192);
    ellipse(-d/2,0,pr,pr);
    ellipse(d/2,0,pr,pr);
    
    blendMode(BLEND);
    stroke(0,16);
    fill(myc,32);
    ellipse(-d/2,0,pr,pr);
    ellipse(d/2,0,pr,pr);
    blendMode(SCREEN);
    
    if (mother) {
      // special case centerpoint labels for root object
      fill(255,248);
      noStroke();
      textSize(33);
      textAlign(CENTER);
      text("YOU",-d/2,30);
      text("ME",d/2,30);
    }
    
    // renderdots
    for (int i=0;i<numdots;i++) {
      float ar = r + dote[i];
      float dx = ar*cos(dotr[i]);
      float dy = ar*sin(dotr[i]);
      
      if (dote[i]>0) {
        float ax = (r+dote[i]-dots[i]/2)*cos(dotr[i]);
        float ay = (r+dote[i]-dots[i]/2)*sin(dotr[i]);
        float bx = r*cos(dotr[i]);
        float by = r*sin(dotr[i]);
        stroke(255,64);
        line(d/2+ax,ay,d/2+bx,by);
        line(-d/2-ax,-ay,-d/2-bx,-by);
      }
      
      fill(255,192);
      ellipse(-d/2-dx,-dy,dots[i],dots[i]);
      ellipse(d/2+dx,dy,dots[i],dots[i]);
      
      if (i==0) {
        // place char
        fill(255,192);
        noStroke();
        pushMatrix();
        translate(d/2,0);
        rotate(dotr[i]);

        translate(0,r-10);
        textSize(22);
        text(ch,0,0);
        textSize(11);
        text(subch,8,8);
        popMatrix();
        
        pushMatrix();
        translate(-d/2,0);
        rotate(dotr[i]+PI);
        translate(0,r-10);
        textSize(22);
        text(ch,0,0);
        textSize(11);
        text(subch,10,4);
        popMatrix();
        
      }
    }
    
    popMatrix();
  }
  
  // create new vesica object
  void subdivide() {
    // not really subdivision
    float nx = x;
    float ny = y;
    float nr = r;
    float ntheta = theta;
    
    float r2 = r/2;
    float interd = sqrt(r*r-r2*r2);
    
    float sign = 1;
    if (random(100)<50) sign=-1;
    
    int style = floor(random(7));
    if (style==0) {
      // horizontal congruent
      nx-=sign*r/2*cos(theta);
      ny-=sign*r/2*sin(theta);
      if (random(100)<50) nr*=.618;
    } else if (style==1) {
      // vertical intersection
      nx+=sign*interd*cos(theta+HALF_PI);
      ny+=sign*interd*sin(theta+HALF_PI);
      if (random(100)<50) nr*=.618;
    } else if (style==2) {
      // rotated intersection
      ntheta -= HALF_PI;
      nx+=sign*interd*cos(theta+HALF_PI);
      ny+=sign*interd*sin(theta+HALF_PI);
      if (random(100)<50) nr*=.618;
    } else if (style==3) {
      // inscribed
      nr*=.333333;
    } else if (style==4) {
      // circumscribed
      nr*=3;
    } else if (style==5) {
      // outbound horizontal
      nx-=sign*2*r*cos(theta);
      ny-=sign*2*r*sin(theta);
      if (random(100)<50) nr*=.618;
      if (random(100)<50) ntheta+=HALF_PI;
    } else if (style==6) {
      // vertical congruent
      nx+=sign*2*interd*cos(theta+HALF_PI);
      ny+=sign*2*interd*sin(theta+HALF_PI);
    }
    
    // randomly rotate into hexagonal space
    if (random(100)<10) ntheta+=TWO_PI/6;
    
    // create the actual object
    Vesica neo = new Vesica(nx,ny,nr,ntheta);
    ves.add(neo);
    
    if (random(100)<56) {
      // mirror creation
      Vesica mir = new Vesica(width-nx,ny,nr,TWO_PI-ntheta);
      ves.add(mir);
    }
    
  }
  
  void arcShape(float cx, float cy, float radius, float radiuss, float startAngle, float endAngle) {
    // Establish arc parameters.
    // (Note: assert th(eta) != TWO_PI)
    float th = endAngle-startAngle;
   
    // Compute raw Bezier coordinates.
    float x0 = cos(th/2.0);
    float y0 = sin(th/2.0);
    float x3 = x0;
    float y3 = 0-y0;
    float x1 = (4.0-x0)/3.0;
    float y1 = ((1.0-x0)*(3.0-x0))/(3.0*y0); // y0 != 0...
    float x2 = x1;
    float y2 = 0-y1;
   
    // Compute rotationally-offset Bezier coordinates, using:
    // x' = cos(angle) * x - sin(angle) * y;
    // y' = sin(angle) * x + cos(angle) * y;
    float bezAng = startAngle + th/2.0;
    float cBezAng = cos(bezAng);
    float sBezAng = sin(bezAng);
    float rx0 = cBezAng * x0 - sBezAng * y0;
    float ry0 = sBezAng * x0 + cBezAng * y0;
    float rx1 = cBezAng * x1 - sBezAng * y1;
    float ry1 = sBezAng * x1 + cBezAng * y1;
    float rx2 = cBezAng * x2 - sBezAng * y2;
    float ry2 = sBezAng * x2 + cBezAng * y2;
    float rx3 = cBezAng * x3 - sBezAng * y3;
    float ry3 = sBezAng * x3 + cBezAng * y3;
   
    // Compute scaled and translated Bezier coordinates.
    float px0 = cx + radius*rx0;
    float py0 = cy + radius*ry0;
    float px1 = cx + radius*rx1;
    float py1 = cy + radius*ry1;
    float px2 = cx + radius*rx2;
    float py2 = cy + radius*ry2;
    float px3 = cx + radius*rx3;
    float py3 = cy + radius*ry3;
   
    bezier(px0,py0, px1,py1, px2,py2, px3,py3);
       
  }
}
