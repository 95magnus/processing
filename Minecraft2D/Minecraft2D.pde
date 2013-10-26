import java.awt.Rectangle;
import java.awt.geom.Line2D;
import java.text.DecimalFormat;
import java.io.FileNotFoundException;

int mapWidth = 100, mapHeight = 90;
int xOffset, yOffset;
int xSpawn = 5, ySpawn = 31;
float playerSpeed = 2.0, gravity = .3, terminalVelocity = 6.0; 
float jumpCooldownTime;
int viewDist;
boolean hasCollided = false, debugGUI = false, inSight;
boolean saving = false;

boolean loadLevelFromFile = false, doneLoading = false;

final String TITLE = "Minecraft 2D", VERSION = "alpha 0.1";
final int SCALE = 3, TILE_SIZE = 16 * SCALE;
final int FPS = 60;

PFont font;
DecimalFormat df = new DecimalFormat("#.00");
boolean[] keys = new boolean[16];
PImage spriteSheet, playerSheet;
HashMap<String, PImage> sprites = new HashMap<String, PImage>();
HashMap<String, PImage> playerSprites = new HashMap<String, PImage>();
Tile[] map;

Player player;

void setup() {
  size(640, 480);
  frameRate(FPS);
  smooth();
  noStroke();
  rectMode(CORNERS);
  font = loadFont("mcFont.vlw");
  textFont(font);

  viewDist = TILE_SIZE * 3;
  jumpCooldownTime = FPS/2; //.5 sec cooldown
  xSpawn *= TILE_SIZE;
  ySpawn *= TILE_SIZE;
  xOffset = xSpawn - (width/3);
  yOffset = ySpawn - (width/3);

  loadImages();
  resetMap(mapWidth, mapHeight);
}

void draw() {
  if (!saving && doneLoading) {
    background(0xffff00ff);
    frame.setTitle(TITLE + " - " + VERSION + " | " + (int)frameRate + " fps");  

    renderMap();
    player.render();
    player.move();
    mouseEvents();
    if (debugGUI) renderDebugOverlay();

    if (player.collision("down") && !hasCollided) { 
      println("On ground"); 
      hasCollided = true;
    }
    if (!player.collision("down") && hasCollided) { 
      println("Not on ground"); 
      hasCollided = false;
    }
  }
}

public void renderDebugOverlay() {
  fill(255); 
  textSize(15);
  text(TITLE + " - " + VERSION + " | " + (int)frameRate + " fps", 5, 20);
  text("playerPos - x: " + df.format((float)player.xMap/TILE_SIZE) + "  y:" + df.format((float)player.yMap/TILE_SIZE), 5, 40);
  text("onGround = " + player.onGround, 5, 60);

  stroke(255, 0, 0);
  if (inSight) stroke(0, 128, 0);
  line(player.eyeXPos, player.eyeYPos, mouseX, mouseY);
}

public void loadImages() {
  spriteSheet = loadImage("spriteSheet.png");
  playerSheet = loadImage("player.png");
  spriteSheet.loadPixels();
  playerSheet.loadPixels();

  sprites.put("air", scaledImg(getSprite(spriteSheet, 0, 0), SCALE));
  sprites.put("dirt", scaledImg(getSprite(spriteSheet, 1, 0), SCALE));
  sprites.put("grass", scaledImg(getSprite(spriteSheet, 2, 0), SCALE));
  sprites.put("stone", scaledImg(getSprite(spriteSheet, 3, 0), SCALE)); 

  playerSprites.put("head", scaledImg(playerSheet.get(0, 12, 8, 8), SCALE)); 
  playerSprites.put("torso", scaledImg(getSprite(playerSheet, 4, 0, 4, 12), SCALE)); 
  playerSprites.put("arm1", scaledImg(getSprite(playerSheet, 0, 0, 4, 12), SCALE)); 
  playerSprites.put("arm2", scaledImg(getSprite(playerSheet, 2, 0, 4, 12), SCALE)); 
  playerSprites.put("leg1", scaledImg(getSprite(playerSheet, 3, 0, 4, 12), SCALE)); 
  playerSprites.put("leg2", scaledImg(getSprite(playerSheet, 1, 0, 4, 12), SCALE));
}
public void saveLevel(String name) {
  println("Saving map...");
  saving = true;

  PrintWriter file = createWriter(name + ".txt");

  //  file.println(player.xMap + "\t" + player.yMap); 

  for (int i = 0; i < map.length; i++) {
    file.println(map[i].name);
  }
  file.flush();
  file.close();
  println("Exiting game");
  exit();
}

public void loadLevel(String path) {
  BufferedReader reader = createReader(path + ".txt");
  ArrayList<String> tiles = new ArrayList<String>(mapWidth * mapHeight);
  String line = null;

  map = new Tile[mapWidth * mapHeight];  
  player = new Player(xSpawn, ySpawn);

  try {
    while ( (line = reader.readLine ()) != null) {
      tiles.add(line);
    }
  }
  catch (FileNotFoundException e) {
    println("File doesn`t exist: " + e);
    loadNewMap(mapWidth, mapHeight);
    return;
  }
  catch (Exception e) {
    println(e);
  }
  finally {
    for (int i = 0; i < map.length; i++) {
      map[i] = new Tile(tiles.get(i), i);
    }
  }
}

public PImage getSprite(PImage sheet, int xSheet, int ySheet) {
  int spriteSize = 16;
  return sheet.get(xSheet * spriteSize, ySheet * spriteSize, spriteSize, spriteSize);
}

public PImage getSprite(PImage sheet, int xSheet, int ySheet, int sWidth, int sHeight) {
  return sheet.get(xSheet * sWidth, ySheet * sHeight, sWidth, sHeight);
}

public PImage scaledImg(PImage img, float scale) {
  PImage image = createImage(img.width * (int)scale, img.height * (int)scale, ARGB);
  image.loadPixels();

  for (int y = 0; y < image.height; y++) {
    int yScale = (int)(y / scale);
    for (int x = 0; x < image.width; x++) {
      int xScale = (int)(x / scale);
      image.pixels[x + y * image.width] = img.pixels[xScale + yScale * img.width];
    }
  }
  image.updatePixels(); 
  return image;
}

public PImage flipped(PImage img) {
  PImage image = createImage(img.width, img.height, ARGB);
  image.loadPixels();

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      image.pixels[x + y * img.width] = img.pixels[(img.width - x) + (img.width - y)* img.width];
    }
  } 
  image.updatePixels();
  return image;
}

public int lineLength(Line2D line) {
  float x1 = (float)line.getX1();
  float x2 = (float)line.getX2();
  float y1 = (float)line.getY1();
  float y2 = (float)line.getY2();

  float x = sq(x1-x2);
  float y = sq(y1-y2);

  return (int) sqrt(x + y);
}

public boolean isNum(String str) {
  try {
    int n = Integer.parseInt(str);
  }
  catch(NumberFormatException e) {
    return false;
  }
  return true;
}

public void renderMap() { 
  for (Tile tiles : map) {
    if (tiles != null)tiles.render(xOffset, yOffset);
  }
}

public void resetMap(int mapWidth, int mapHeigth) {
  if (loadLevelFromFile) {
    loadLevel("level");
  }
  else {
    loadNewMap(mapWidth, mapHeigth);
  }
  doneLoading = true;
}

public void loadNewMap(int mapWidth, int mapHeigth) {
  player = new Player(xSpawn, ySpawn);
  map = new Tile[mapWidth * mapHeight];  

  for (int y = 0; y < mapHeight; y++) {
    for (int x = 0; x < mapWidth; x++) {
      int index = x + y * mapWidth;
      if (y < 32)map[index] = new Tile("air", index);
      if (y == 32)map[index] = new Tile("grass", index);
      if (y > 32 && y < 34)map[index] = new Tile("dirt", index);
      if (y >= 34)map[index] = new Tile("stone", index);

      map[index].setPos(index);
    }
  }
}

public void mouseEvents() {
  int xTile = (mouseX + xOffset) / TILE_SIZE;
  int yTile = (mouseY + yOffset) / TILE_SIZE;
  int index = xTile + yTile * mapWidth;

  Line2D lineOfSight = new Line2D.Float(player.eyeXPos + xOffset, player.eyeYPos + yOffset, mouseX + xOffset, mouseY + yOffset);
  inSight = true;
  for (Tile t : map) {
    if (t.bounds == null) t.setBounds();
    if (lineLength(lineOfSight) > viewDist || (t.tileIndex != map[index].tileIndex && t.isSolid() && lineOfSight.intersects(t.bounds))) inSight = false;
  }
  if (inSight && map[index].isSolid())map[index].renderBounds(index);

  //if (debugGUI)line((float)lineOfSight.getX1() - xOffset, (float)lineOfSight.getY1() - yOffset, (float)lineOfSight.getX2() - xOffset, (float)lineOfSight.getY2() - yOffset);

  if (mousePressed && inSight) {
    if (mouseButton == LEFT && map[index].name != "air") map[index] = new Tile("air", index); 
    if (mouseButton == RIGHT && map[index].name == "air") map[index] = new Tile("dirt", index);
    map[index].setPos(index);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP)keys[0] = true;
    if (keyCode == RIGHT)keys[1] = true;
    if (keyCode == DOWN)keys[2] = true;
    if (keyCode == LEFT)keys[3] = true;
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP)keys[0] = false;
    if (keyCode == RIGHT)keys[1] = false;
    if (keyCode == DOWN)keys[2] = false;
    if (keyCode == LEFT)keys[3] = false;
  }
  if (keyCode == BACKSPACE)saveLevel("level");
  if (keyCode == ENTER) debugGUI = !debugGUI;
}

int xCoord(int tileIndex) {
  return (tileIndex % mapWidth) * TILE_SIZE;
}

int yCoord(int tileIndex) {
  return ((tileIndex - (tileIndex % mapWidth)) / mapWidth) * TILE_SIZE;
}

