int max_bodies = 800000;
int body_count;
Body[] bodies = new Body[max_bodies];
color black = color(0, 0, 0);
int cycles_per_frame = 1;
int frame = 0;

void setup() {
  size(480, 480, P2D);
  frameRate(30);
  background(0);
  body_count = 0;
}

void keyPressed() {
  bodies[body_count] = new Body(body_count, int(random(width)), int(random(height)), int(random(45) + 5));
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
  int n, c, weight;
  float x, y, dx, dy;
  
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

  void run(int frame) {
    for(int i=0; i < body_count; i++) {
      if (i != n) {
        float angle = atan2(y - bodies[i].y, x - bodies[i].x) + PI;
        float distance = dist(x, y, bodies[i].x, bodies[i].y);
        float ddx = 300 * cos(angle) * bodies[i].weight / weight / (distance*distance);
        float ddy = 300 * sin(angle) * bodies[i].weight / weight / (distance*distance);
        if (ddx >  0.2) ddx =  0.2;
        if (ddx < -0.2) ddx = -0.2;
        if (ddy >  0.2) ddy =  0.2;
        if (ddy < -0.2) ddy = -0.2;
        dx += ddx;
        dy += ddy;
      }
    }
    
    // float angle = atan2(y - height/2, x - width/2) + PI;
    // float distance = dist(x, y, width/2, height/2);
    // float ddx = 10000 * cos(angle) * weight * distance / 500000000;
    // float ddy = 10000 * sin(angle) * weight * distance / 500000000;
    // 
    // dx += ddx;
    // dy += ddy;
    
    float ox = x;
    float oy = y;
    x += dx;
    y += dy;
    
    float Z = 1.0;
    
    if (int(x) > width) {
      x = 2 * width - x;
      dx = -dx * random(Z);
    }

    if (x < 0) {
      x = -x;
      dx = -dx * random(Z);
    }

    if (int(y) > height) {
      y = 2 * height - y;
      dy = -dy * random(Z);
    }

    if (y < 0) {
      y = -y;
      dy = -dy * random(Z);
    }

    stroke(c);
    line(ox, oy, x, y);
    // set(int(x), int(y), c);
  }
}
