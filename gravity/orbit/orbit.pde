// This sketch is currently broken! :)

int max_bodies = 800000;
int body_count;
Body[] bodies = new Body[max_bodies];
color black = color(0, 0, 0);
int cycles_per_frame = 2;
int frame = 0;

void setup() {
  size(480, 480, P2D);
  frameRate(30);
  background(0);
  body_count = 0;
  stroke(200);
}

void keyPressed() {
  bodies[body_count] = new Body(body_count, int(random(width)), int(random(height)), 5);
  body_count++;
}

void draw() {
  noStroke();
  fill(0,0,0, 10);
  rect(0, 0, width, height);
  frame++;
  for (int z=0; z<cycles_per_frame; z++) {
    for (int i = 0; i < body_count; i++) {
      bodies[i].run(frame);
    }
  }
}

class Body {
  int n, x, y, c, weight;
  double dx, dy;
  
  Body(int number, int start_x, int start_y, int given_weight) {
    n = number;
    x = start_x;
    y = start_y;
    weight = given_weight;
    c = color(random(155) + 100, random(155) + 100, random(155) + 100);
    dx = (random(2) - 1) * 3;
    dy = (random(2) - 1) * 3;
    dx = 0;
    dy = 0;
  }

  void run() {
    for(int i=0; i < body_count; i++) {
      if (i != n) {
        float distance = sqrt((x - bodies[i].x)^2 + (y - bodies[i].y)^2);
        // stroke(int(255/distance));
        // line(x, y, bodies[i].x, bodies[i].y);

        if (distance > 0) {
          int xd = (bodies[i].x - x);
          double ddx = 10 * bodies[i].weight / weight / (xd*xd*xd);
          int yd = (bodies[i].y - y);
          double ddy = 10 * bodies[i].weight / weight / (yd*yd*yd);
      
          // stroke(200);
          // line(int(x), int(y), x + dx * 10, y + dy * 10);
          dx += ddx;
          dy += ddy;
        }
      }
    }
    int ox = x;
    int oy = y;
    x += dx;
    y += dy;
    stroke(100);
    line(ox, oy, x, y);
    set(x, y, c);
  }
}
