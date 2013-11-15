class Tile {
  int x, y, size, num = 2;
  int x0, x1, y0, y1;
  boolean isBomb, isShown = true;

  /*  
   private enum State{
   HIDDEN(0), 
   EMPTY(1), 
   BOMB(2), 
   NUMBER(3); 
   
   private int code;
   
   private State(int code){
   this.code = code;
   }
   
   public void setState(int stateCode){
   this.code = satteCode; 
   }
   
   public int getCode(){
   return code; 
   }
   }
   
   */
  public Tile(int x, int y, boolean bomb) {
    this.x = x;
    this.y = y;
    this.size = TILE_SIZE;
    this.isBomb = bomb;
    //if (!isBomb) setNum();

    x0 = x - (TILE_SIZE/2); 
    x1 = x + (TILE_SIZE/2); 
    y0 = y - (TILE_SIZE/2);
    y1 = y + (TILE_SIZE/2);
  }

  public void render() {
    if (!isShown) {
      drawNotShown();
    }    
    else if (isShown && isBomb) {
      drawBomb();
    }
    else {
      //Draw gray square
      rectMode(CENTER);
      fill(200);
      rect(x, y, size, size);
      
      drawNum();
    }
    rectMode(CENTER);
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(x, y, size, size);
  }

  private void drawNotShown() {
    noStroke();
    fill(228);
    triangle(x0, y1, x0, y0, x1, y0);
    fill(128);
    triangle(x0, y1, x1, y1, x1, y0);

    rectMode(CENTER);
    fill(192);
    rect(x, y, size-6, size-6);
  }

  private void drawBomb () {
    rectMode(CENTER);
    fill(200);
    stroke(0);
    rect(x, y, size, size);
    ellipseMode(CENTER);
    fill(0);
    ellipse(x, y, size/2, size/2);
  }

  private void drawNum() {
    //stroke(255, 0, 0);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    if (num != -1)text(x, y, num);
  }

  private void setNum() {
    for (int i = 0; i < tiles.length; i++) {
      // if (tiles )
    }
  }
}

