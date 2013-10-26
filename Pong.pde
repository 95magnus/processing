//input
boolean keyLeftUp = false;
boolean keyLeftDown = false;
boolean keyRightUp = false;
boolean keyRightDown = false;

//Ball varables
float ballPosX, ballPosY;
float dx = -5, dy = 5;
int ballSize = 50;
boolean behindPaddle = false;

//Paddle variables
float lPos, rPos;
float paddleSpeed = 5.0f;

int scoreLeft, scoreRight;

boolean isPlaying = false;

PFont font; 

void setup(){
 size(720, 480); 
 frameRate(60);
 noStroke();
 smooth();
 
 font = createFont("Arial", 20, true);
 textFont(font); 
 
 ballPosX = width/2; 
 ballPosY = height/2;
 
 lPos = height / 2;
 rPos = height / 2;
 
}

void leftPaddle(){
  if (keyLeftUp)lPos -= paddleSpeed;
  if (keyLeftDown)lPos += paddleSpeed;
  
  rectMode(CENTER);
  fill(0,255,0);
  
  if (lPos - 50 <= 0) lPos = 55;
  if (lPos + 50 >= height) lPos = height - 55;
  rect(50, lPos, 15, 100, 5);
}

void rightPaddle(){
  if (keyRightUp)rPos -= paddleSpeed;
  if (keyRightDown)rPos += paddleSpeed;
  
  rectMode(CENTER);
  fill(0,255,0);
  
  if (rPos - 50 <= 0) rPos = 55;
  if (rPos + 50 >= height) rPos = height - 55;
  rect(width - 50, rPos, 15, 100, 5);  
}

void outOfBounds(boolean left){
  if (left){
    scoreLeft++;
  }else {
    scoreRight++;
  }
  
  dy = (dy > 0) ? -5 : 5;
  dx = (dx > 0) ? -5 : 5;
  
  System.out.println("Left: " + scoreLeft + " - Right: " + scoreRight); 
}

void changeDir(char dir){
  if (dir == 'x')dx = -dx;
  if (dir == 'y')dy = -dy;
}

void ball(float xPos, float yPos){  
    fill(0,255,0);
    ellipse(xPos, yPos, ballSize, ballSize); 
}

void keyPressed(){
  if (key == CODED){
    if (keyCode == SHIFT)keyLeftUp = true;
    if (keyCode == CONTROL)keyLeftDown = true;
    if (keyCode == UP)keyRightUp = true;
    if (keyCode == DOWN)keyRightDown = true;
  }  
}
void keyReleased(){
  if (key == CODED){
    if (keyCode == SHIFT)keyLeftUp = false;
    if (keyCode == CONTROL)keyLeftDown = false;
    if (keyCode == UP)keyRightUp = false;
    if (keyCode == DOWN)keyRightDown = false;
  }  
}

void draw(){
  background(0);
  
  if(isPlaying){    
    //println(lPos + ", " + rPos + " - " + ballPosX + ", " + ballPosY);
  
   //Ball out of bounds
   if (ballPosX >= width + (ballSize / 2)){
     outOfBounds(true);
     behindPaddle = false;
     changeDir('x');
     ballPosX = width / 2;
    } 
    if (ballPosX <= -(ballSize / 2)){
     outOfBounds(false);
     behindPaddle = false;  
     ballPosX = width / 2;
     changeDir('x');
    }
    
    if (ballPosX < 50)behindPaddle = true;
    if (ballPosX > width - 50)behindPaddle = true;
    
    //Ball collision
    if (ballPosY >= height - (ballSize / 2)){
      ballPosY = height - (ballSize / 2);
      changeDir('y');
    }
    if (ballPosY <= (ballSize / 2)){
      ballPosY = (ballSize / 2);       
      changeDir('y');
    } 
    
    //Left paddle collision 
    if (!behindPaddle && ballPosX <= 58 + (ballSize / 2) && ballPosY > lPos - 55 && ballPosY < lPos + 55){
      changeDir('x');
    } 
    //Right paddle collision
    if (!behindPaddle && ballPosX >= (width - 58) - (ballSize / 2) && ballPosY > rPos - 55 && ballPosY < rPos + 55){
      changeDir('x');
    } 
        
    ballPosX += dx;
    ballPosY += dy;
    
    ball(ballPosX, ballPosY);

    //Render score
    fill(0, 255, 0);
    textAlign(CENTER);
    text("Left: " + scoreLeft + " - Right: " + scoreRight, (width/2), 20);
      
    leftPaddle();
    rightPaddle();

    println(dy);      
    
    dy *= 1.0003f;
    dx *= 1.0001f;
    
    }else {
    if (key == ' ')isPlaying = true;
    
    scoreLeft = 0;
    scoreRight = 0;
    
    println(dy);
    
    fill(0, 255, 0);
    textAlign(CENTER);
    text("Press SPACE to start the game", (width/2), height/3);
    text("Controls:", (width/2), (height/2));
    text("Left player - SHIFT + LCTRL", (width/2), (height/2) + 20);
    text("Right player - UP + DOWN", (width/2), (height/2) + 40);
  }
}

