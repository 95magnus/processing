import java.text.DecimalFormat;

int GUIHeight = 50;
int bombCount, timer = 0, time = 0;
byte difficulty = 1;
boolean timing = false, isGenerated = false;
/*
DIFFICULTY - gridWidth, gridWidth, mines
 
 EASY - 8 * 8, 10
 MEDIUM - 16 * 16, 50
 HARD - 32 * 32, 100
 */
final int TILE_SIZE = 32;

DecimalFormat df = new DecimalFormat("00");
Screen screen = new Screen();
Field field  = new Field();
Tile[] tiles = new Tile[64];

void setup() {
  size(640, 480);
  smooth();
  noStroke();
  frame.setResizable(true);
  //frame.setSize(width, height);
  frame.setTitle("Minesweeper");

  field.generateMinefield(difficulty * 8, difficulty * 8, 25);
}

void draw() {
  background(192);
  frame.setSize(9 * TILE_SIZE, (10 * TILE_SIZE) + GUIHeight);
  if (isGenerated) {
    if (timing && time % 60 == 0) timer++;
    time++;

    screen.render();
  }
}

void mouseClicked() {
  if (isGenerated) {
    for (int i = 0; i < tiles.length; i++) {
      int size = tiles[i].size;
      if (mouseButton == LEFT) {
        if (!tiles[i].isShown && mouseX > tiles[i].x - (size/2) && mouseX < tiles[i].x + (size/2) && mouseY > tiles[i].y - (size/2) && mouseY < tiles[i].y + (size/2)) {
          tiles[i].isShown = !tiles[i].isShown;
          if (!timing)timing = true;
        }
      }
    }
  }
}

