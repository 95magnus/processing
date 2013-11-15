class Player{
  int xScreen, yScreen, xMap, yMap, cooldownTime = 0, time = 0;
  int spriteWidth, spriteHeight, headSize, playerHeight;
  float yVelocity, speed, swing = 0, swingSpeed = .1, angle = 0, armAngle = 0;
  boolean onGround, jumping, moving, movingLeft, punching;
  HashMap<String, Line2D> bounds = new HashMap<String, Line2D>(4);
  PVector eyePos;

  public Player(int x, int y) {
    this.xMap = x;
    this.yMap = y;
    
    spriteWidth = playerSprites.get("torso").width;
    spriteHeight = playerSprites.get("torso").height;
    headSize = playerSprites.get("head").width;
    playerHeight = (spriteHeight * 2) + headSize - (2 * SCALE);
    eyePos = new PVector((xMap - xOffset) - (headSize/2), (yMap - yOffset) - (playerHeight - (headSize/2)));
  
    println(spriteHeight);
  }

  public void render() {
    //println(PVector.angleBetween(eyePos, mouse));
    fill(255, 0, 0);
    setBounds();
   
    eyePos = (mouseX < xScreen) ? new PVector((xMap - xOffset) - (headSize/2), (yMap - yOffset) - (playerHeight - (headSize/2))) : new PVector((xMap - xOffset) + (headSize/2), (yMap - yOffset) - (playerHeight - (headSize/2)));
    
    xScreen = xMap - xOffset;
    yScreen = yMap - yOffset;

    if (xScreen > width - (width / 3)) {
      xScreen = width - (width / 3);
      xOffset += playerSpeed;
    }
    if (xScreen < width / 3) {
      xScreen = width / 3;
      xOffset -= playerSpeed;
    }

    if (yScreen > height - (height / 3)) {
      yScreen = height - (height / 3);
      yOffset += yVelocity;
    }
    if (yScreen < height / 3) {
      yScreen = height / 3;
      yOffset -= yVelocity;
    }

    if (moving) {
      angle += swingSpeed;
      swing = sin(angle);

      pushMatrix();
      translate(xScreen, yScreen - spriteHeight);
      rotate(swing);
      image(playerSprites.get("leg2"), -(spriteWidth/2), 0);
      popMatrix();

      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) + (2 * SCALE));
      rotate(-swing);
      image(playerSprites.get("arm2"), -(spriteWidth/2), 0);
      popMatrix();

      image(playerSprites.get("torso"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));

      pushMatrix();
      translate(xScreen, yScreen - spriteHeight);
      rotate(-swing);
      image(playerSprites.get("leg1"), -(spriteWidth/2), 0);
      popMatrix();

      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) + (2 * SCALE));
      rotate(swing);
      image(playerSprites.get("arm1"), -(spriteWidth/2), 0);
      popMatrix();
    }
    else {
      angle = 0;
      image(playerSprites.get("leg2"), xScreen - (spriteWidth / 2), yScreen - spriteHeight);
      image(playerSprites.get("leg1"), xScreen - (spriteWidth / 2), yScreen - spriteHeight);
      image(playerSprites.get("arm2"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
      image(playerSprites.get("torso"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
      if (!punching)image(playerSprites.get("arm1"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
      if (punching) {
        armAngle += speed; 
        pushMatrix();
        translate(xScreen- (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE) + (spriteWidth/2));

        if (mouseX < xScreen) {
          rotate(armAngle);
        }
        else {
          rotate(-armAngle);
        }

        image(playerSprites.get("arm1"), -(spriteWidth/2), 0);
        popMatrix();
      }
    }

    if (mouseX < xScreen) { 
      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) - (headSize/2) + (2 * SCALE));
      scale(-1, 1);
      //rotate(-PVector.angleBetween(eyePos, mouse)+(PI/4));
      image(playerSprites.get("head"), -(headSize/2), - (headSize/2));
      popMatrix();
    }
    else {
      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) - (headSize/2) + (2 * SCALE));
      //rotate(-PVector.angleBetween(eyePos, mouse)+(PI/4));
      image(playerSprites.get("head"), -(headSize/2), - (headSize/2));
      popMatrix();
    }
  }

  private void startPunchAnim() {
    armAngle = 0;
  }

  public void move() {

    cooldownTime++;
    onGround = collision("down") ? true : false;

    yVelocity = onGround ? 0 : yVelocity < terminalVelocity ? yVelocity += gravity: terminalVelocity;

    if (keys[0] && onGround && cooldownTime > jumpCooldownTime) {
      yVelocity = TILE_SIZE * 1.5;
      cooldownTime = 0;
      yMap -= yVelocity;
    }  
    if (keys[1] && !collision("right")) {
      xMap += playerSpeed;
    }
    if (!collision("down") && !onGround) {
      yMap += yVelocity;
    }
    if (keys[3] && !collision("left")) {
      xMap -= playerSpeed;
    }
    moving = (keys[1] || keys[3]) ? true : false;
    movingLeft = (keys[3]) ? true : false;
  }

  private void setBounds() {
    bounds.clear();
    bounds.put("down", new Line2D.Float(xMap - (headSize / 2) + 2, yMap, xMap + (headSize / 2) - 2, yMap));     
    bounds.put("up", new Line2D.Float(xMap - (headSize / 2) + 2, yMap - playerHeight, xMap + (headSize / 2) - 2, yMap - playerHeight));     
    bounds.put("left", new Line2D.Float(xMap - (headSize / 2), yMap - 5, xMap - (headSize / 2), yMap - playerHeight + 5));     
    bounds.put("right", new Line2D.Float(xMap + (headSize / 2), yMap - 5, xMap + (headSize / 2), yMap - playerHeight + 5));
  }

  private boolean collision(String name) {
    for (Tile t : map) {
      if (t.bounds == null)t.setBounds();
      if (t.isSolid() && bounds.get(name).intersects(t.bounds)) return true;
    }
    return false;
  }
}

