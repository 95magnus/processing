class Screen{
  
  public Screen(){}
  
  public void render(){
    for (int i = 0; i < tiles.length; i++){
      tiles[i].render();
    }
  }
}
