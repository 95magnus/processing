Checkbox[] checkbox;
Button button;

void setup() {
  size(640, 480);
  smooth();
  textSize(20);

  checkbox = new Checkbox[4];
  button = new Button(200, 200, "Change color");

  for (int i = 0; i < checkbox.length; i++) {
    checkbox[i] = new Checkbox(100, 100 + (i * 25));
  }
}

void draw() {
  background(0, 255, 0);
  if (button.pressed)background(0, 0, 255); 

  for (Checkbox cb : checkbox) {
    cb.render();
  }

  button.render();
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    for (Checkbox cb : checkbox) {
      cb.changeState(mouseX, mouseY);
    }
    button.pressed(mouseX, mouseY);
  }
}

class Checkbox {
  int x, y, size = 20;
  boolean checked = false;

  public Checkbox(int x, int y) {
    this.x = x; 
    this.y = y;
  }

  public void render() {
    rectMode(CENTER);
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(x, y, size, size);
    if (checked) { 
      line(x - (size / 2), y - (size / 2), x + (size / 2), y + (size /2));
      line(x - (size / 2), y + (size / 2), x + (size / 2), y - (size / 2));
    }
  }

  public void changeState(int xMouse, int yMouse) {
    if (xMouse > x - (size/2) && xMouse < x + (size/2) && yMouse > y - (size/2) && yMouse < y + (size/2)) checked = !checked;
  }
}

class Button {
  int x, y, bWidth = 10, bHeight, padding = 10;
  String text = "Button";
  int textSize = 20;
  boolean pressed = false;

  public Button(int x, int y, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
    bWidth = (int)textWidth(text) + padding;
    bHeight = textSize + padding;
  } 

  public void render() {
    rectMode(CORNER);
    textAlign(CENTER, TOP);
    stroke(0);
    strokeWeight(1);
    fill(0);
    rect(x+1, y+1, bWidth+1, bHeight+1, 5);
    fill(255);
    if (mousePressed && (mouseX > x && mouseX < x + bWidth && mouseY > y && mouseY < y + bHeight)) {
      rect(x+1, y+1, bWidth+1, bHeight+1, 5);
      fill(0);
      text(text, x+1 + (bWidth/2), y+1 + (padding/2));
    }
    else {
      rect(x, y, bWidth, bHeight, 5);
      fill(0);
      text(text, x + (bWidth/2), y + (padding/2));
    }
  }

  public void pressed(int xMouse, int yMouse) {
    if (xMouse > x && xMouse < x + bWidth && yMouse > y && yMouse < y + bHeight) {
      pressed = !pressed;
      println("Pressed");
    }
  }
}

