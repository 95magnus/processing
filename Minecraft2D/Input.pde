class Input {
  boolean inSight;
  Line2D lineOfSight;

  public Input() {
  }

  public void mouseEvents() {
    int xTile = (mouseX + xOffset) / TILE_SIZE;
    int yTile = (mouseY + yOffset) / TILE_SIZE;
    int index = xTile + yTile * mapWidth;

    lineOfSight = new Line2D.Float(player.eyePos.x + xOffset, player.eyePos.y + yOffset, mouseX + xOffset, mouseY + yOffset);
    inSight = true;
    for (Tile t : map) {
      if (t.bounds == null) t.setBounds();
      if (lineLength(lineOfSight) > viewDist || (t.tileIndex != map[index].tileIndex && t.isSolid() && lineOfSight.intersects(t.bounds))) inSight = false;
    }
    if (inSight && map[index].isSolid())map[index].renderBounds(index);

    if (mousePressed && inSight) {
      if (mouseButton == LEFT && map[index].name != "air") map[index] = new Tile("air", index); 
      if (mouseButton == RIGHT && map[index].name == "air") map[index] = new Tile("dirt", index);
      map[index].setPos(index);
      player.startPunchAnim();
    }
  }
}
