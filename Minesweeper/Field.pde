public class Field {
  int fieldWidth, fieldHeight;

  public Field() {
  }

  public void generateMinefield(int gridWidth, int gridHeight, int bombsPercent) {
    this.fieldWidth = gridWidth;
    this.fieldHeight = gridHeight;
    
    
    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        int tileX = ((TILE_SIZE - (TILE_SIZE / 3)) + x * TILE_SIZE);
        int tileY = GUIHeight + (TILE_SIZE - (TILE_SIZE / 3)) + (y * TILE_SIZE);
        
        tiles[x + y * gridWidth] = new Tile(tileX, tileY, randomBoolean(bombsPercent));
        if (tiles[x + y * gridWidth].isBomb) bombCount++;
      }
    }
    isGenerated = true;
  }

  private boolean randomBoolean(int percentage) {
    if (random(99) < percentage)return true;
    return false;
  }
  
  public int getFieldWidth(){
    return fieldWidth; 
  } 
  
  public int getFieldHeight(){
    return fieldHeight; 
  } 
}

