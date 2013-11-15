import java.text.DecimalFormat;

int w, h;
int fieldWidth = 8, fieldHeight = 8;
int GUIHeight = 50;
int bombCount, timer = 0, time = 0;
byte difficulty = 1;
boolean timing = false, isGenerated = false;
/*
DIFFICULTY - gridWidth, gridWidth, mines(percent)
 
 EASY - 8 * 8, 10
 MEDIUM - 16 * 16, 50
 HARD - 32 * 32, 100
 */
final int TILE_SIZE = 32;

DecimalFormat df = new DecimalFormat("00");
Screen screen = new Screen();
Field field  = new Field();
Tile[] tiles;

void setup() {
  size(640, 480);
  smooth();
  noStroke();
  frame.setResizable(true);
  frame.setTitle("Minesweeper");

  tiles = new Tile[64];
  field.generateMinefield(fieldWidth, fieldHeight, 25);
  w = field.getWidth();
  h = field.getHeight();
}

void draw() {
  background(192);
  frame.setSize(TILE_SIZE * w, ((h+1) * TILE_SIZE) + GUIHeight);
  
  if (isGenerated) {
    if (timing && time % 60 == 0) timer++;
    screen.render();
    time++;
  }
}

void mouseClicked() {
  if (isGenerated) {
    for (int i = 0; i < tiles.length; i++) {
      int size = tiles[i].size;
      if (mouseButton == LEFT) {
        if (!tiles[i].isShown && mouseX > tiles[i].x - (size/2) && mouseX < tiles[i].x + (size/2) && mouseY > tiles[i].y - (size/2) && mouseY < tiles[i].y + (size/2)) {
          if (!timing)timing = true;
          tiles[i].isShown = !tiles[i].isShown;
        }
      }
    }
  }
}
