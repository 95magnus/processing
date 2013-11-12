class Tile {
  String name;
  int x, y, tileIndex, xScroll, yScroll;
  PImage sprite; 
  boolean solid = false;
  Rectangle bounds; 

  public Tile (String name, int tileIndex) {
    this.name = name;
    this.tileIndex = tileIndex;
    this.x = xCoord(tileIndex);
    this.y = yCoord(tileIndex);
  } 

  public void render(int xScroll, int yScroll) {
    this.xScroll = xScroll;
    this.yScroll = yScroll;
    image(sprites.get(name), x - xScroll, y - yScroll);
    setBounds();
  }

  public void renderBounds(int tileIndex) {
    int x = xCoord(tileIndex) - xScroll;
    int y = yCoord(tileIndex) - yScroll;
    noFill();
    stroke(0);
    rect(x, y, x + TILE_SIZE, y + TILE_SIZE);
  }

  public void setBounds() {
    bounds = new Rectangle(x, y, TILE_SIZE, TILE_SIZE);
  }

  public void setPos(int tileIndex) {
    this.tileIndex = tileIndex;
    this.x = xCoord(tileIndex);
    this.y = yCoord(tileIndex);
  }

  public boolean isSolid() {
    if (name.equals("air")) return false;
    return true;
  }
}

