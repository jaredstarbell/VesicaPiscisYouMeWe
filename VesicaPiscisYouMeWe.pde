// Vesica Piscis: You, Me, We
//   Jared S Tarbell
//   January 2, 2020
//   Levitated Toy Factory
//   Albuquerque, New Mexico USA
//   Processing 3.5.3
//
// A meditative geometric construction of our relationship. 

ArrayList<Vesica> ves = new ArrayList<Vesica>();
color[] fColor = {#ff9966, #ccff00, #ff9933, #ff00cc, #ee34d3, #4fb4e5, #abf1cf, #ff6037, #ff355e, #66ff66, #ffcc33, #ff6eff, #ffff66, #fd5b78};

boolean doDivide = true;

int resetAt;
int cnt;
  
PFont font;


void setup() {
  //size(1200,1200,FX2D);
  fullScreen(FX2D);
  background(0);
  blendMode(SCREEN);
  smooth(8);

  // font stuff for the labels 
  font = createFont("brinathyn.ttf",33);
  textFont(font);
  textAlign(CENTER);

  // initialize and begin
  init();
}

void init() {
  // remove any previously created objects
  ves.clear();
  
  // create a mother vesica object for 'you' and 'me'
  Vesica neo = new Vesica(width/2,height/2,200,0);
  neo.mother = true;
  neo.render();
  ves.add(neo);
  
  // two counters to determine rate at which new objects are added
  cnt = 0;
  resetAt = 300;
}

void draw() {
//  background(0);
//  for (Vesica v:ves) {
//    v.update();
//    v.render();
//  }

  // later in the sketch, begin to place the 'we' dark label
  if (cnt>1600 && cnt%60==0) {
    blendMode(BLEND);
    fill(0,8);
    textSize(33);
    textAlign(CENTER);
    text("WE",width/2,height/2-4);
    blendMode(SCREEN);
  }

  // increment counter each frame
  cnt++;
  if (resetAt>0) {
    if (cnt%resetAt==0) {
      if (doDivide) subdivide();
      // shorten the time between subdivisions
      resetAt-=ceil(resetAt*.05);
    }
  } else {
    if (doDivide) subdivide();
  }
    
}

void subdivide() {
  // duplicate and offset some random vesica
  if (ves.size()>0) {
    int i = floor(random(ves.size()));
    Vesica v = ves.get(i);
    v.subdivide();
  }
}

color somecolor() {
  int i = floor(random(fColor.length));
  return fColor[i];
}

void keyPressed() {
  if (key==' ') {
    // press spacebar to generate new composition
    background(0);
    init();
  }
}

void mousePressed() {
  // toggle dividing flag
  doDivide = !doDivide;
}
