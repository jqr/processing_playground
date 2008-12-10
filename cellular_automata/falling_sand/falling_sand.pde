World w;
int maxgrains = 80000;
int grain_count;
Grain[] grains = new Grain[maxgrains];
color wall;
color black = color(0, 0, 0);
// set lower for smoother animation, higher for faster simulation
int runs_per_loop = 1000;
boolean faucet = true;

void setup()
{
  size(640, 200, P2D);
  frameRate(60);
  clearscr();
  w = new World();
  wall = color(255, 0, 0);
  grain_count = 0;
  seed();
}

void seed() {
  for (int i = 0; i < 100; i++) {
    int cX = int(random(width));
    int cY = int(random(height - 40)) + 40;
    float r = random(1);

    for (int z = 0; z < 30; z++) {
      w.setpix(cX + z, cY, wall);
    }
  }
}

void mousePressed() {
  faucet = !faucet;
}

void draw() {
  if (faucet) {
    int cX = width / 3;
    int cY = 3;
    
    for (int i=0; i< 5; i++ ) {
      if (w.getpix(cX + i, cY) == black) {
        w.setpix(cX + i, cY, 0);
        grains[grain_count] = new Grain(cX + i, cY);
        grain_count++;
      }
    }
    
    cX = width / 3 * 2;
    for (int i=0; i< 5; i++ ) {
      if (w.getpix(cX + i * 2, cY) == black) {
        w.setpix(cX + i * 2, cY, 0);
        grains[grain_count] = new Grain(cX + i * 2, cY);
        grain_count++;
      }
    }
  }
  
  for (int i = 0; i < grain_count; i++) {
    grains[i].run();
  }
}

void clearscr() {
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      set(x, y, color(0));
    }
  }
}

class Grain {
  int x, y;
  
  Grain(int start_x, int start_y) {
    x = start_x;
    y = start_y;
  }

  void run() {
     if (random(100) > 99) return;
    // Fix grain coordinates
    while(x < 0) {
      x+=width;
    }
    while(x > width - 1) {
      x-=width;
    }
    while(y < 0) {
      y+=height;
    }
    while(y > height - 1) {
      y-=height;
    }
    
    if (w.getpix(x, y + 1) == black) move(0, 1);
    else if ((w.pressure(x, y) > 1) && (w.getpix(x - 1, y) == black)) move(-1, 0);
    else if ((w.pressure(x, y) > 1) && (w.getpix(x + 1, y) == black)) move(1, 0);
    else {
      w.setpix(x, y,31);
    }

  }
  
  void move(int dx, int dy) {
    if (w.getpix(x + dx, y + dy) == black) {
      w.setpix(x + dx, y + dy, w.getpix(x, y));
      w.setpix(x, y, color(0));
      x += dx;
      y += dy;
    }
  }
}

class World {
  
  void setpix(int x, int y, int c) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;

    if (c != wall && c != black) {
      c = int(pressure(x, y)) * 10 + 65;
      c = color(c,c,c);
    }
    set(x, y, c);
  }
  
  color getpix(int x, int y) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    if (y > height - 1) return(1);
    return get(x, y);
  }
  
  boolean has_spore(int x, int y) {
    int p = 0;
    p = get(x, y);
    return (p == black) || (p == wall);
  }
  
  float pressure(int x, int y) {

    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    return max(pressure_above(x - 1, y), pressure_above(x, y - 1), pressure_above(x + 1, y -1));
//    return(pressure_at(x, y, 0));
  }
  
  float pressure_at(int x, int y, int depth) {
    if (has_spore(x, y)) return 0;
    if (depth > 2) return 0;
    return (
      pressure_at(x - 1, y - 1, depth + 1) +
      pressure_at(x    , y - 1, depth + 1) +
      pressure_at(x + 1, y - 1, depth + 1)
    )/3 + 1;
  }

  int pressure_above(int x, int y) {
    for (int i = 0; i < y; i++) {
      if (has_spore(x, y - i)) return(i);
    }
    return(0);
  }
    
}

