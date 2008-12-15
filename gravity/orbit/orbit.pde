int max_bodies = 800000;
int body_count;
Body[] bodies = new Body[max_bodies];
color black = color(0, 0, 0);
int cycles_per_frame = 1;

void setup() {
  size(480, 480, P2D);
  frameRate(30);
  background(0);
  body_count = 0;
}

void keyPressed() {
  bodies[body_count++] = new Body(int(random(width)), int(random(height)), int(random(10)));
}

void draw() {
  for (int z=0; z<cycles_per_frame; z++) {
    for (int i = 0; i < body_count; i++) {
      bodies[i].run();
    }
  }
}

class Body {
  int x, y, c, weight;
  
  Body(int start_x, int start_y, int given_weight) {
    x = start_x;
    y = start_y;
    weight = given_weight;
    c = color(random(255), random(255), random(255));
  }

  void run() {
    set(x, y, c);
  }
}
