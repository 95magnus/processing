public class Field {
  int fieldWidth, fieldHeight;

  public Field() {}

  public void generateMinefield(int gridWidth, int gridHeight, int bombCount) {
    this.fieldWidth = gridWidth+1;
    this.fieldHeight = gridHeight+1;
    
    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        int tileX = ((TILE_SIZE - (TILE_SIZE / 3)) + x * TILE_SIZE);
        int tileY = GUIHeight + (TILE_SIZE - (TILE_SIZE / 3)) + (y * TILE_SIZE);
        
        tiles[x + y * gridWidth] = (bombCount < 10 && randomBoolean()) ? new Tile(tileX, tileY, true) : new Tile(tileX, tileY, false);
        if (tiles[x + y * gridWidth].isBomb) bombCount++;
      }
    }
    isGenerated = true;
  }

  private boolean randomBoolean() {
    if (random(2) <= 1)return true;
    return false;
  }
  
  public int getWidth(){
    return fieldWidth; 
  } 
  
  public int getHeight(){
    return fieldHeight; 
  } 
}

