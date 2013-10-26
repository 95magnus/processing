int pacPos, headSize;
int tileWidth, tileHeight;
int dotSize, dotCount = 0;
int time = 0, score;
int currentLevel = 0;
boolean playing = false, died = false;
int lives = 3;

final String TITLE = "Pac Man 2.0";
final String START = "Press SPACE to start the game!";
final String RESTART = "Press SPACE to restart!";
final String DEATH_MESSAGE = "You died :(";
final int TILE_SIZE = 40;
final int FPS = 60;
final int LEVELS = 2;

int voidColor = 0xff000000; 
int dotColor = 0xffffffff;
int wallColor = 0xff404040;
int pacStartColor = 0xff808080; 
int enemyStartColor = 0xffff0000; 

boolean keys[] = new boolean[8];
Tile[] tile;
Enemy[] enemies = new Enemy[4];

PImage[] enemiesImg = new PImage[4];
PImage[] level = new PImage[LEVELS];

PacMan pac;

void setup() {
  size(760, 640);
  frameRate(FPS);
  noStroke();
  smooth();
  rectMode(CENTER);
  textAlign(CENTER);

  tileWidth = width / TILE_SIZE;
  tileHeight = height / TILE_SIZE;
  tile = new Tile[tileWidth * tileHeight];

  headSize = TILE_SIZE - 4;
  dotSize = TILE_SIZE / 2;

  loadImages();
  loadLevel();
}

void draw() {
  background(0);
  input();
  timer();
  frame.setTitle(TITLE + " | Level " + (currentLevel + 1) + " | Score: " + score +  " | " + (int)frameRate + " fps");  
  
  for (Tile t : tile) {
    t.render();
  }

  renderGUI();

  if (playing && !died) {
    println(lives);
    if (lives == 0)died = true;
    if (score >= dotCount) {
      currentLevel++;
      if (currentLevel > LEVELS-1) currentLevel = 0;
      resetLevel();
      resetEntities();
    }

    for (Enemy enemy : enemies) {
      enemy.render();
      enemy.move();
    }

    eatDot();
    pac.render();
    pac.move();
  }
}

public void loadImages() {
  String[] enemyPaths = {
    "enemy_blue.png", "enemy_green.png", "enemy_orange.png", "enemy_red.png"
  };

  for (int i = 0; i < level.length; i++){
    level[i] = loadImage("level_" + Integer.toString(i) + ".png");
    level[i].loadPixels();
  }
  
  for (int i = 0; i < enemyPaths.length; i++) {
    enemiesImg[i] = loadImage(enemyPaths[i]);
  }
}

public void loadLevel() {
  for (int i = 0; i < level[currentLevel].pixels.length; i++) {
    if (level[currentLevel].pixels[i] == voidColor) tile[i] = new Tile(i, 0);
    if (level[currentLevel].pixels[i] == dotColor) tile[i] = new Tile(i, 1);
    if (level[currentLevel].pixels[i] == wallColor) tile[i] = new Tile(i, 2);
    if (level[currentLevel].pixels[i] == pacStartColor || level[currentLevel].pixels[i] == enemyStartColor)tile[i] = new Tile(i, 0);
  }
}

public void resetLevel() {
  for (int i = 0; i < level[currentLevel].pixels.length; i++) {
    if (level[currentLevel].pixels[i] == voidColor) tile[i] = new Tile(i, 0);
    if (level[currentLevel].pixels[i] == dotColor) {  
      tile[i] = new Tile(i, 1);
      dotCount++;
    }
    if (level[currentLevel].pixels[i] == wallColor) tile[i] = new Tile(i, 2);
    if (level[currentLevel].pixels[i] == pacStartColor || level[currentLevel].pixels[i] == enemyStartColor)tile[i] = new Tile(i, 0);
  }
}

public void resetEntities() {
  int index = 0;
  for (int i = 0; i < level[currentLevel].pixels.length; i++) {
    if (level[currentLevel].pixels[i] == enemyStartColor) {
      enemies[index] = new Enemy(i, index);
      enemies[index].startMoving();
      index++;
    }
    if (level[currentLevel].pixels[i] == pacStartColor) pacPos = i;
  }
  pac = new PacMan(pacPos);
}

public void renderGUI(){
  if (!playing) {
    fill(255);
    textSize(20);
    text(START, width/2, height/2);
    fill(255, 255, 0);
    stroke(2);
    textSize(50);
    text("PacMan", width/2, height/2 - 60);
    noStroke();
  }

  if (died) {
    fill(255, 0, 0);
    textSize(30);
    text(DEATH_MESSAGE, width/2, height/2 + 20);
    textSize(20);
    fill(255);
    text("You got to level " + Integer.toString(currentLevel+1) + "!", width/2, height/2 + 60);
    text("Score: " + score, width/2, height/2 + 80);
    text(RESTART, width/2, height/2 + 120);
    dotCount = 0;
  } 
  
  if (playing && !died){
    fill(255);
    textSize(20);
    textAlign(LEFT);
    text("Level " + Integer.toString(currentLevel+1), 5, 25);
    
    fill(255);
    textSize(20);
    textAlign(RIGHT);
    text("Score: " + Integer.toString(score), width - 5, 25);
    
    for (int i = 0; i < lives; i++){
      fill(255,255,0);
      arc(20 + (i * (headSize - 5)), height -20, headSize-10, headSize-10, radians(30), radians(330));    
    }
    
    textAlign(CENTER);
  }
}

public void eatDot() {
  for (int i = 0; i < level[currentLevel].pixels.length; i++) {
    if (pac.getTileIndex() == i && tile[i].id == 1) {
      tile[i].id = 0;
      score++;
    }
  }
}

public void timer() {
  time++;
  if (time > 100000) time = 0;
}

int xCoord(int tileIndex) {
  return ((tileIndex % tileWidth) * TILE_SIZE) + (TILE_SIZE / 2);
}

int yCoord(int tileIndex) {
  return (((tileIndex - (tileIndex % tileWidth)) / tileWidth) * TILE_SIZE) + (TILE_SIZE / 2);
}

void input() {
  if (keys[0]) pac.dir = 0;
  if (keys[1]) pac.dir = 1;
  if (keys[2]) pac.dir = 2;
  if (keys[3]) pac.dir = 3;
}

void keyPressed() {
  if (key == CODED && playing) {
    if (keyCode == UP)keys[0] = true;
    if (keyCode == RIGHT)keys[1] = true;
    if (keyCode == DOWN)keys[2] = true;
    if (keyCode == LEFT)keys[3] = true;
  }
  
  if ((key == ' ' && !playing) || (key == ' ' && died)) {
    playing = true;
    died = false;
    lives = 3;
    score = 0;
    resetLevel();
    resetEntities();
  }
}

void keyReleased() {
  if (key == CODED && playing) {
    if (keyCode == UP)keys[0] = false;
    if (keyCode == RIGHT)keys[1] = false;
    if (keyCode == DOWN)keys[2] = false;
    if (keyCode == LEFT)keys[3] = false;
  }
}

public class PacMan {
  int tileIndex;
  byte dir = 1;
  boolean moving = false;

  public PacMan(int tileIndex) {
    this.tileIndex = tileIndex;
  }

  public void render() {
    fill(255, 255, 0);
    noStroke();
    if (dir == 0)arc(xCoord(tileIndex), yCoord(tileIndex), headSize, headSize, radians(-60), radians(240));
    if (dir == 1)arc(xCoord(tileIndex), yCoord(tileIndex), headSize, headSize, radians(30), radians(330));    
    if (dir == 2)arc(xCoord(tileIndex), yCoord(tileIndex), headSize, headSize, radians(-240), radians(60));  
    if (dir == 3)arc(xCoord(tileIndex), yCoord(tileIndex), headSize, headSize, radians(-150), radians(150));
    if (time % (FPS/2) <= 3 && moving)ellipse(xCoord(tileIndex), yCoord(tileIndex), headSize, headSize);
  }

  public void move() {
    if (collided()) moving = false;

    for (Enemy enemy : enemies) {
      if (enemy.getTileIndex() == pac.getTileIndex()){
        resetEntities();
        lives--; 
      }
    }

    if (time % (FPS/2) == 0) {
      if (dir == 0 && !collided()) {
        moving = true;
        tileIndex -= tileWidth;
      }
      if (dir == 1 && !collided()) {
        moving = true;
        tileIndex++;
      }
      if (dir == 2 && !collided()) {
        moving = true;
        tileIndex += tileWidth;
      }
      if (dir == 3 && !collided()) { 
        moving = true;
        tileIndex--;
      }
    }
  }

  private boolean collided() {
    if (dir == 0 && tile[tileIndex - tileWidth].isSolid())return true;
    if (dir == 1 && tile[tileIndex + 1].isSolid())return true;
    if (dir == 2 && tile[tileIndex + tileWidth].isSolid())return true;
    if (dir == 3 && tile[tileIndex - 1].isSolid())return true;
    return false;
  }

  public int getTileIndex() {
    return tileIndex;
  }
}

public class Enemy {
  int tileIndex, enemyColor;
  byte dir = 1;
  int imgId;

  public Enemy(int tileIndex, int imgId) {
    this.tileIndex = tileIndex;
    this.imgId = imgId;
    this.dir = (byte)random(4);
  }

  public void render() {
    image(enemiesImg[imgId], xCoord(tileIndex) - (TILE_SIZE/2), yCoord(tileIndex) - (TILE_SIZE/2));
  }

  public void move() {
    if (time % (FPS/2) == 0) {
      if (dir == 0 && !collided(dir)) tileIndex -= tileWidth;
      if (dir == 1 && !collided(dir)) tileIndex++;
      if (dir == 2 && !collided(dir)) tileIndex += tileWidth;
      if (dir == 3 && !collided(dir)) tileIndex--;
    }
    dir = getNewDir(dir);
  }

  public void startMoving() {
    dir = (byte)random(4);
  }

  private boolean collided(byte direction) {
    if (direction == 0 && tile[tileIndex - tileWidth].isSolid()) return true;
    if (direction == 1 && tile[tileIndex + 1].isSolid()) return true;
    if (direction == 2 && tile[tileIndex + tileWidth].isSolid()) return true;
    if (direction == 3 && tile[tileIndex - 1].isSolid()) return true;
    return false;
  }

  private byte getNewDir(byte previousDir) {
    ArrayList<Byte> validDirList = new ArrayList<Byte>();

    for (byte i = 0; i < 4; i++){
      if (!collided(i) && !oppositeDir(i, previousDir)) validDirList.add(i); 
    }
    return validDirList.get((int)random(validDirList.size()));
  }
  
  private boolean oppositeDir(byte d1, byte d2){
    if (d1 == 0 && d2 == 2)return true; 
    if (d1 == 1 && d2 == 3)return true; 
    if (d1 == 2 && d2 == 0)return true; 
    if (d1 == 3 && d2 == 1)return true; 
    return false;
  }
  
  public int getTileIndex() {
    return tileIndex;
  }
}

/*
IDs:
 0 - voidTile
 1 - dotTile
 2 - wallTile
 */

public class Tile {
  private int x, y, id; 

  public Tile(int tileIndex, int id) {
    this.x = xCoord(tileIndex);
    this.y = yCoord(tileIndex);
    this.id = id;
  }

  public void render() {
    if (id == 0) {
      fill(0);
      rect(x, y, TILE_SIZE, TILE_SIZE);
    }
    if (id == 1) {
      fill(255);
      ellipse(x, y, dotSize, dotSize);
    }
    if (id == 2) {
      fill(wallColor);
      rect(x, y, TILE_SIZE, TILE_SIZE);
    }
  }

  public boolean isSolid() {
    if (id == 2)return true;
    return false;
  }
}

