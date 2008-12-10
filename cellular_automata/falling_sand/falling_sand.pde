World w;
int maxgrains = 80000;
int grain_count;
Grain[] grains = new Grain[maxgrains];
color black = color(0, 0, 0);

void setup() {
  size(640, 200, P2D);
  frameRate(60);
  background(0);
  w = new World();
  grain_count = 0;
}

void mousePressed() {
  w.toggle_facuet();
}

void draw() {
  if (w.faucet) {
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

class Grain {
  int x, y;
  
  Grain(int start_x, int start_y) {
    x = start_x;
    y = start_y;
  }

  void run() {
    // 1% of the time, refuse to move
    if (random(100) > 99) return;

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
  boolean faucet;
  color wall = color(255, 0, 0);
  
  World() {
    faucet = true;
    add_obstacles();
  }
  
  void add_obstacles() {
    for (int i = 0; i < 100; i++) {
      int x = int(random(width));
      int y = int(random(height - 40)) + 40;

      for (int z = 0; z < 30; z++) {
        setpix(x + z, y, wall);
      }
    }
  }
  
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
  
  void toggle_facuet() {
    faucet = !faucet;
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

