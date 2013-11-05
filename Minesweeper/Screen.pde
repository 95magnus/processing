class Screen{
  
  public Screen(){}
  
  public void render(){
    //Render tiles
   if (isGenerated) for (int i = 0; i < tiles.length; i++) tiles[i].render();

    renderGUI();
  }
  
  private void renderGUI(){
    //Top field
    rectMode(CORNERS);
    fill(128);
    noStroke();
    rect(0, 0, width, GUIHeight);
    
    //timer
    rectMode(CENTER);
    fill(64,128);
    rect(width - (width/5), GUIHeight/2, 100, GUIHeight - GUIHeight/4);
    fill(0,255,0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text((timer - (timer % 60)) / 60 + ":" + df.format(timer % 60), width - (width/5), GUIHeight/2);
      
    //bomb count
    rectMode(CENTER);
    fill(64,128);
    rect(width/5, GUIHeight/2, 100, GUIHeight - GUIHeight/4);
    fill(0,255,0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text(bombCount, width/5, GUIHeight/2);
  }
}
