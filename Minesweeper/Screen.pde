class Screen{
  
  public Screen(){}
  
  public void render(){
    //Render tiles
    for (int i = 0; i < tiles.length; i++) tiles[i].render();

    renderGUI();
  }
  
  private void renderGUI(){
    //Top field
    rectMode(CORNERS);
    fill(128);
    noStroke();
    rect(0, 0, width, heightGUI);
    
    //Center - timer
    rectMode(CENTER);
    fill(64,128);
    rect(width/2, heightGUI/2, 100, heightGUI - heightGUI/4);
    fill(0,255,0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text((timer - (timer % 60)) / 60 + ":" + timer % 60, width/2, heightGUI/2);
      
    //Left - bomb count
    rectMode(CENTER);
    fill(64,128);
    rect(width/5, heightGUI/2, 100, heightGUI - heightGUI/4);
    fill(0,255,0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text(bombCount, width/5, heightGUI/2);
  }
}
