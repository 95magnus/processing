class Zombie {
  int xMap, yMap, xScreen, yScreen;
  int spriteWidth, spriteHeight, headSize, zombieHeight;
  float angle = 0, swingSpeed = .1, swing = 0;
  HashMap<String, Line2D> bounds = new HashMap<String, Line2D>(4);
  boolean moving = true;

  public Zombie(int x, int y) {
    this.xMap = x;
    this.yMap = y;
    
    spriteWidth = 4 * SCALE;
    spriteHeight = 12 * SCALE;
    headSize = 8 * SCALE;
    zombieHeight = (spriteHeight * 2) + headSize - (2 * SCALE);
  }

  public void render() {
    xScreen = xMap - xOffset;
    yScreen = yMap - yOffset;
    
    if (moving){
      angle += swingSpeed;
      swing = sin(angle);

      pushMatrix();
      translate(xScreen, yScreen - spriteHeight);
      rotate(swing);
      image(zombieSprites.get("leg2"), -(spriteWidth/2), 0);
      popMatrix();
/*
      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) + (2 * SCALE));
      rotate(-swing);
      image(zombieSprites.get("arm2"), -(spriteWidth/2), 0);
      popMatrix();
*/
      image(zombieSprites.get("torso"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));

      pushMatrix();
      translate(xScreen, yScreen - spriteHeight);
      rotate(-swing);
      image(zombieSprites.get("leg1"), -(spriteWidth/2), 0);
      popMatrix();

      pushMatrix();
      translate(xScreen, yScreen - (spriteHeight * 2) + (2 * SCALE));
      rotate(PI/2);
      image(zombieSprites.get("arm1"), -(spriteWidth/2), 0);
      popMatrix();
    }
    else {
      angle = 0;
      image(zombieSprites.get("leg2"), xScreen - (spriteWidth / 2), yScreen - spriteHeight);
      image(zombieSprites.get("leg1"), xScreen - (spriteWidth / 2), yScreen - spriteHeight);
      image(zombieSprites.get("arm2"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
      image(zombieSprites.get("torso"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
      /*
      if (!punching)image(zombieSprites.get("arm1"), xScreen - (spriteWidth / 2), yScreen - (spriteHeight * 2) + (2 * SCALE));
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

        image(zombieSprites.get("arm1"), -(spriteWidth/2), 0);
        popMatrix();
      }*/
    }
  }

  public void move() {
  }

  private void setBounds() {
    bounds.clear();
    bounds.put("down", new Line2D.Float(xMap - (headSize / 2) + 2, yMap, xMap + (headSize / 2) - 2, yMap));     
    bounds.put("up", new Line2D.Float(xMap - (headSize / 2) + 2, yMap - zombieHeight, xMap + (headSize / 2) - 2, yMap - zombieHeight));     
    bounds.put("left", new Line2D.Float(xMap - (headSize / 2), yMap - 5, xMap - (headSize / 2), yMap - zombieHeight + 5));     
    bounds.put("right", new Line2D.Float(xMap + (headSize / 2), yMap - 5, xMap + (headSize / 2), yMap - zombieHeight + 5));
  }

  private boolean collison(String name) {
    for (Tile t : map) {
      if (t.bounds == null)t.setBounds();
      if (t.isSolid() && bounds.get(name).intersects(t.bounds)) return true;
    }
    return false;
  }
}

