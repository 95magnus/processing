class Tile {
  int x, y, size;
  int x0, x1, y0, y1;
  boolean isBomb, isShown = true;

  public Tile(int x, int y, boolean bomb) {
    this.x = x;
    this.y = y;
    this.size = TILE_SIZE;
    this.isBomb = bomb;

    x0 = x - (TILE_SIZE/2); 
    x1 = x + (TILE_SIZE/2); 
    y0 = y - (TILE_SIZE/2);
    y1 = y + (TILE_SIZE/2);
  }

  public void render() {
    if (!isShown) {
      noStroke();
      fill(228);
      triangle(x0, y1, x0, y0, x1, y0);
      fill(128);
      triangle(x0, y1, x1, y1, x1, y0);

      rectMode(CENTER);
      fill(192);
      rect(x, y, size-6, size-6);
    }    
    else if (isShown && isBomb) {
      rectMode(CENTER);
      fill(200);
      stroke(0);
      rect(x, y, size, size);
      ellipseMode(CENTER);
      fill(0);
      ellipse(x, y, size/2, size/2);
    }
    else {
      rectMode(CENTER);
      fill(200);
      rect(x, y, size, size);
    }
    rectMode(CENTER);
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(x, y, size, size);
  }
}

