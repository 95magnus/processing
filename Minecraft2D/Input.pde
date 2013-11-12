class Input {


  public Input() {
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
      player.punched = true;
    }else {
      player.punched = false;
    }
  }
}

