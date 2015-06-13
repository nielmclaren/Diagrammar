
class EmojiPlayer extends EmojiParticle {
  float maxVelocity;
  float acceleration;
  PVector acc;
  
  boolean isUp;
  boolean isDown;
  boolean isLeft;
  boolean isRight;
  
  EmojiPlayer(int identifier) {
    super(identifier, new PVector(width/2, height/2), new PVector());
    
    maxVelocity = 4;
    acceleration = 0.1;
    
    acc = new PVector();
    
    isUp = false;
    isDown = false;
    isLeft = false;
    isRight = false;
  }
  
  void step() {
    acc.x = 0;
    acc.y = 0;
    
    if (isUp) {
      acc.y -= acceleration;
    }
    if (isDown) {
      acc.y += acceleration;
    }
    if (isLeft) {
      acc.x -= acceleration;
    }
    if (isRight) {
      acc.x += acceleration;
    }
    
    vel.add(acc);
    if (vel.mag() > maxVelocity) {
      vel.mult(maxVelocity / vel.mag());
    }
    
    super.step();
  }
  
  void keyPressed() {
    switch (keyCode) {
      case UP:
        isUp = true;
        break;
      case DOWN:
        isDown = true;
        break;
      case LEFT:
        isLeft = true;
        break;
      case RIGHT:
        isRight = true;
        default:
    }
  }
  
  void keyReleased() {
    switch (keyCode) {
      case UP:
        isUp = false;
        break;
      case DOWN:
        isDown = false;
        break;
      case LEFT:
        isLeft = false;
        break;
      case RIGHT:
        isRight = false;
        default:
    }
  }
}
