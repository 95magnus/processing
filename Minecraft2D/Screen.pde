class Screen {
  public Screen() {
  } 

  public void renderDebugOverlay() {
    fill(255); 
    textSize(15);
    text(TITLE + " - " + VERSION + " | " + (int)frameRate + " fps", 5, 20);
    text("playerPos - x: " + df.format((float)player.xMap/TILE_SIZE) + "  y:" + df.format((float)player.yMap/TILE_SIZE), 5, 40);
    text("onGround = " + player.onGround, 5, 60);

    stroke(255, 0, 0);
    if (inSight) stroke(0, 128, 0);
    line(player.eyeXPos, player.eyeYPos, mouseX, mouseY);

    if (debugGUI) {
      fill(0xffff00ff);
      noStroke();
      rect(player.eyeXPos - 3, player.eyeYPos - 3, player.eyeXPos + 3, player.eyeYPos + 3);

      stroke(0xffff00ff);
      ellipseMode(RADIUS);
      noFill();
      ellipse(player.eyeXPos, player.eyeYPos, viewDist, viewDist);
      noStroke();
    }
  }
}

