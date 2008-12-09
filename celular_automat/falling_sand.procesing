/**
 * Spore 2 
 * by Mike Davis. 
 * 
 * A short program for alife experiments. Click in the window to restart. 
 * Each cell is represented by a pixel on the display as well as an entry in
 * the array 'cells'. Each cell has a run() method, which performs actions
 * based on the cell's surroundings.  Cells run one at a time (to avoid conflicts
 * like wanting to move to the same space) and in random order. 
 */
 
World w;
int maxcells = 80000;
int numcells;
Cell[] cells = new Cell[maxcells];
color spore1, spore2;
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
  spore1 = color(128, 172, 255);
  spore2 = color(255, 0, 0);
  numcells = 0;
  seed();
}

void seed()
{
  // Add cells at random places
  for (int i = 0; i < 100; i++)
  {
    int cX = int(random(width));
    int cY = int(random(height - 40)) + 40;
    int c;
    float r = random(1);
     c = spore2;

    for (int z = 0; z < 30; z++) {
      w.setpix(cX + z, cY, c);
    }
  }
}

void draw()
{
  if (faucet) {
    int cX = width/2;
    int cY = 3;
    
    for (int i=0; i< 5; i++ ) {
      if (w.getpix(cX + i, cY) == black) {
        w.setpix(cX + i, cY, spore1);
        cells[numcells] = new Cell(cX + i, cY);
        numcells++;
      }
    }
  }
  
  for (int i = 0; i < numcells; i++) {
    cells[i].run();
  }
}

void clearscr()
{
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      set(x, y, color(0));
    }
  }
}

class Cell
{
  int x, y;
  Cell(int xin, int yin)
  {
    x = xin;
    y = yin;
  }
  // Perform action based on surroundings
  void run()
  {
     if (random(100) > 99) return;
    // Fix cell coordinates
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
//    println(w.pressure(x, y));
    
    if (w.getpix(x, y + 1) == black) move(0, 1);
//    else if (w.getpix(x - 1, y + 1) == black) move(-1, 1);
//    else if (w.getpix(x + 1, y + 1) == black) move(1, 1);
    else if ((w.pressure(x, y) > 1) && (w.getpix(x - 1, y) == black)) move(-1, 0);
    else if ((w.pressure(x, y) > 1) && (w.getpix(x + 1, y) == black)) move(1, 0);
    else {
//     w.pressurize(x - 1, y);
//     w.pressurize(x + 1, y);
//
//     w.pressurize(x, y + 1);
//     w.pressurize(x - 1, y + 1);
//     w.pressurize(x + 1, y + 1);
      w.setpix(x, y,31);
    }

  }
  
  // Will move the cell (dx, dy) units if that space is empty
  void move(int dx, int dy) {
    if (w.getpix(x + dx, y + dy) == black) {
      w.depressurize(x, y);
      w.setpix(x + dx, y + dy, w.getpix(x, y));
      w.setpix(x, y, color(0));
      x += dx;
      y += dy;
    }
  }
}

//  The World class simply provides two functions, get and set, which access the
//  display in the same way as getPixel and setPixel.  The only difference is that
//  the World class's get and set do screen wraparound ("toroidal coordinates").
class World
{
  int[][] pressures = new int[width][height];
  
  
  void setpix(int x, int y, int c) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    if (c != spore2 && c != black) {
//      if (pressure(x, y) > 0) println(pressure(x, y)) ;
      c = int(pressure(x, y)) * 10 + 65;
      c = color(c,c,c);
    }
    set(x, y, c);
  }
  
  color getpix(int x, int y) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
//    while(y > height - 1) y-=height;
    if (y > height - 1) return(1);
    return get(x, y);
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

  boolean has_spore(int x, int y) {
    int p = 0;
    p = get(x, y);
    return (p == black) || (p == spore2);
  }

  int pressure_above(int x, int y) {
    for (int i = 0; i < y; i++) {
      if (has_spore(x, y - i)) return(i);
    }
    return(0);
  }
  
  void pressurize(int x, int y) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    pressures[x][y] += 1;
//    println("pressurize: " + pressures[x][y]);
  }
  
  void depressurize(int x, int y) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    pressures[x][y] = 0;
  }
}

void mousePressed()
{
  faucet = !faucet;
}
