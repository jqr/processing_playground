import processing.video.*;        

World w;
int maxgrains = 800000;
int grain_count;
Grain[] grains = new Grain[maxgrains];
color black = color(0, 0, 0);
int cycles_per_frame = 1;
Capture video;
int s = 5;

void setup() {
  size(480, 480, P2D);
  frameRate(30);
  background(0);
  w = new World();
  grain_count = 0;
  video = new Capture(this, 48, 48, 30);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      w.change_faucet(1);
    } else if (keyCode == DOWN) {
      w.change_faucet(-1);
    } 
  } else {
    w.toggle_facuet();
  }
}

void draw() {
  
  if (video.available()) {
    noStroke();

    for (int x = 0; x < video.width; x++) {

      for (int y = 0; y < video.height; y++) { 
        video.read();
        video.loadPixels();
       
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image
        
        float b = brightness(video.pixels[loc]);

        color spot = get(x*s, y*s + 200);

        if (b > 100 && b < 200) {
          fill(w.wall);
          rect(x*s + 0, y*s + 200, s, s);
        } else {

          if (spot == w.wall) {
            fill(black);
            rect(x*s + 0, y*s + 200, s, s);
          }
        }


      }
    }
  }
  
  for (int z=0; z<cycles_per_frame; z++) {
    w.draw();

    for (int i = 0; i < grain_count; i++) {
      grains[i].run();
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
    // 0.5% of the time, refuse to move
    if (random(1000) > 995) return;

    if      (w.could_move(x, y + 1)                          ) move(+0, 1);
    else if (w.could_move(x - 1, y) && (w.pressure(x, y) > 0)) move(-1, 0);
    else if (w.could_move(x + 1, y) && (w.pressure(x, y) > 0)) move(+1, 0);
    else {
      // w.setpix(x, y, 1); // force a pixel redraw
    }

  }

  void move(int dx, int dy) {
    w.setpix(x, y, black);
    x += dx;
    y += dy;
    w.setpix(x, y, 1);
  }
}

class World {
  boolean faucet;
  int faucet_strength = 50;
  color wall = color(255, 0, 0);

  World() {
    faucet = true;
  }

  void draw() {
    if (faucet) {
      int cX = 20;
      int cY = 3;

      for (int i=0; i < w.faucet_strength; i++ ) {
        if (w.getpix(cX + i * 2, cY) == black) {
          w.setpix(cX + i * 2, cY, 0);
          grains[grain_count] = new Grain(cX + i * 2, cY);
          grain_count++;
        }
      }

      cX = width - 20;
      for (int i=0; i < w.faucet_strength; i++ ) {
        if (w.getpix(cX - i * 2, cY) == black) {
          w.setpix(cX - i * 2, cY, 0);
          grains[grain_count] = new Grain(cX - i * 2, cY);
          grain_count++;
        }
      }
    }
  }

  boolean valid_coordinates(int x, int y) {
    return((x >= 0) && (x < width) && (y >= 0) && (y < height));
  }

  boolean could_move(int x, int y) {
    return(valid_coordinates(x, y) && getpix(x, y) == black);
  }

  void change_faucet(int delta) {
    faucet_strength += delta;
  }

  void setpix(int x, int y, color c) {
    if (c != wall && c != black) {
      int pc = int(pressure(x, y) * 30 + 100);
      c = color(pc, pc, pc);
    }
    set(x, y, c);
  }

  color getpix(int x, int y) {
    return get(x, y);
  }

  boolean has_grain(int x, int y) {
    int p = 0;
    p = get(x, y);
    return !((p == black) || (p == wall));
  }

  void toggle_facuet() {
    faucet = !faucet;
  }

  float pressure(int x, int y) {
    if (has_grain(x    , y - 1)) return(1);
    return(0);
  }
}

