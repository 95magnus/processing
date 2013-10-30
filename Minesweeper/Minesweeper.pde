int gridWidth, gridHeight, heightGUI = 50;
byte difficulty = 0;

static final int TILE_SIZE = 32;

Screen screen = new Screen();
Tile[] tiles = new Tile[16];

void setup() {
  size(640, 480);
  smooth();
  noStroke();
  frame.setResizable(true);
  //frame.setSize(width, height);
  frame.setTitle("Minesweeper");

  for (int y = 0; y < 4; y++) {
    for (int x = 0; x < 4; x++) {
      tiles[x + y * 4] = new Tile(100 + (int)(x * TILE_SIZE*1), 100 + (int)(y * TILE_SIZE*1), true);
    }
  }

  gridWidth = width / TILE_SIZE;
  gridHeight = height - heightGUI;
}

void draw() {
  background(192);

  screen.render();
}

void mouseClicked() {
  for (int i = 0; i < tiles.length; i++) {
    int size = tiles[i].size;
    if (mouseButton == LEFT) {
      if (mouseX > tiles[i].x - (size/2) && mouseX < tiles[i].x + (size/2) && mouseY > tiles[i].y - (size/2) && mouseY < tiles[i].y + (size/2))tiles[i].isShown = !tiles[i].isShown;
    }
  }
}

