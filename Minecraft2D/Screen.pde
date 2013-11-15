class Screen {
  public Screen() {
  } 

  public void renderDebugOverlay() {
    fill(255); 
    textSize(15);
    text(TITLE + " - " + VERSION + " | " + (int)frameRate + " fps", 5, 20);
    text("playerPos - x: " + df.format((float)player.xMap/TILE_SIZE) + "  y:" + df.format((float)player.yMap/TILE_SIZE), 5, 40);
    text("onGround: " + player.onGround, 5, 60);
    text("moving: " + player.moving, 5, 80);

    stroke(255, 0, 0);
    if (input.inSight) stroke(0, 128, 0);
    line(player.eyePos.x, player.eyePos.y, mouseX, mouseY);

    if (debugGUI) {
      fill(0xffff00ff);
      noStroke();
      rect(player.eyePos.x - 3, player.eyePos.y - 3, player.eyePos.x + 3, player.eyePos.y + 3);

      stroke(0xffff00ff);
      ellipseMode(RADIUS);
      noFill();
      ellipse(player.eyePos.x, player.eyePos.y, viewDist, viewDist);
      noStroke();
    }
  }
}

