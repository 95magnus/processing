class Player {
  int xScreen, yScreen, xMap, yMap, eyeXPos, eyeYPos;
  int cooldownTime = 0, time = 0;
  float yVelocity, speed;
  float swing = 0, swingSpeed = .1, angle = 0;
  boolean onGround, jumping, moving, punched;
  HashMap<String, Line2D> pBounds = new HashMap<String, Line2D>();

  float a = 0;
        
 
  boolean flipped = false;
  int spriteWidth = playerSprites.get("torso").width;
  int spriteHeight = playerSprites.get("torso").height;
  int headSize = playerSprites.get("head").width;
  int playerHeight = (spriteHeight * 2) + headSize - (2 * SCALE);

  public Player(int x, int y) {
    this.xMap = x;
    this.yMap = y;
  }

  public void render() {
    fill(255, 0, 0);
    setBounds();
    //println(xMap + "-" + yMap);
    eyeXPos = (xMap - xOffset) + (headSize/2);
    eyeYPos = (yMap - yOffset) - (playerHeight - (headSize/2));

    //    eyeXPos = xMap + (headSize/2);
    //  eyeYPos = yMap - (playerHeight - (headSize/2));

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
      
      pushMatrix();
      translate(xScreen, yScreen - spriteHeight);
      rotate(swing);
      image(playerSprites.get("leg2"), -(spriteWidth/2),0);
      popMatrix();
      
      pushMatrix();
      translate(xScreen, yScreen - spriteHeight);
      rotate(-swing);
      image(playerSprites.get("leg1"), -(spriteWidth/2),0);
      popMatrix();

      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) + (2 * SCALE));
      rotate(-swing);
      image(playerSprites.get("arm2"), -(spriteWidth/2), 0);
      popMatrix();

      image(playerSprites.get("head"), xScreen - (headSize / 2), yScreen - (spriteHeight * 2) - headSize + (2 * SCALE));
      image(playerSprites.get("torso"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));

      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) + (2 * SCALE));
      rotate(swing);
      image(playerSprites.get("arm1"), -(spriteWidth/2), 0);
      popMatrix();
    }
    else {
      if (punched){
        a = (a > PI/2) ? a+swingSpeed*2 : a - swingSpeed*2;
        
        pushMatrix();
        translate(xScreen, yScreen - (spriteHeight * 2) + (2 * SCALE) + (spriteWidth/2));
        if (mouseX < xScreen){
          rotate(PI/2);
        }else{
          rotate(-PI/2);
        }
        
        image(playerSprites.get("arm1"), -(spriteWidth/2), 0);
        popMatrix();
      }
      
      image(playerSprites.get("head"), xScreen - (headSize / 2), yScreen - (spriteHeight * 2) - headSize + (2 * SCALE));
      image(playerSprites.get("leg2"), xScreen - (spriteWidth / 2), yScreen - spriteHeight);
      image(playerSprites.get("leg1"), xScreen - (spriteWidth / 2), yScreen - spriteHeight);
      image(playerSprites.get("arm2"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
      image(playerSprites.get("torso"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
      image(playerSprites.get("arm1"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
    }


    angle = (moving) ? angle + swingSpeed : 0;
    if (moving)swing = sin(angle);

    if (debugGUI) {
      fill(0xffff00ff);
      noStroke();
      rect(eyeXPos - 3, eyeYPos - 3, eyeXPos + 3, eyeYPos + 3);

      stroke(0xffff00ff);
      ellipseMode(RADIUS);
      noFill();
      ellipse(eyeXPos, eyeYPos, viewDist, viewDist);
      noStroke();
    }
  }

  public void move() {
    cooldownTime++;
    onGround = collision("down") ? true : false;
    yVelocity = onGround ? 0 : yVelocity < terminalVelocity ? yVelocity += gravity : terminalVelocity;

    /*
  if(IsGrounded()) {
     //vSpeed = 0;
     yVelocity = 0;
     
     if(Input.GetButtonDown("Jump"){
     vSpeed = 5;
     }
     
     yVelocity -= gravity * Time.deltaTime;
     vSpeed += yVelocity * Time.deltaTime;
     */

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
    /*    
     if (collision("up") && !onGround) {
     yVelocity = 0;
     }
     */
  }

  private void setBounds() {
    pBounds.clear();
    pBounds.put("down", new Line2D.Float(xMap - (headSize / 2) + 2, yMap, xMap + (headSize / 2) - 2, yMap));     
    pBounds.put("up", new Line2D.Float(xMap - (headSize / 2) + 2, yMap - playerHeight, xMap + (headSize / 2) - 2, yMap - playerHeight));     
    pBounds.put("left", new Line2D.Float(xMap - (headSize / 2), yMap - 5, xMap - (headSize / 2), yMap - playerHeight + 5));     
    pBounds.put("right", new Line2D.Float(xMap + (headSize / 2), yMap - 5, xMap + (headSize / 2), yMap - playerHeight + 5));
  }

  private boolean collision(String name) {
    for (Tile t : map) {
      if (t.bounds == null)t.setBounds();
      if (t.isSolid() && pBounds.get(name).intersects(t.bounds)) return true;
    }
    return false;
  }
}

