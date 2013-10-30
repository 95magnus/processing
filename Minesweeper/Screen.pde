class Screen{
  
  public Screen(){}
  
  public void render(){
    renderTiles();
    renderGUI();
  }
  
  private void renderGUI(){
    rectMode(CORNERS);
    fill(128);
    noStroke();
    rect(0, 0, width, heightGUI);
    
    rectMode(CENTER);
    fill(64,128);
    rect(width/2, heightGUI/2, 100, heightGUI - heightGUI/4);
  }
  
  private void renderTiles(){
    for (int i = 0; i < tiles.length; i++){
      tiles[i].render();
    }
  }
}
