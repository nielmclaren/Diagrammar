
class EmojiPlayer extends EmojiParticle {
  private float _maxVelocity;
  private float _acceleration;
  private PVector _acc;

  private boolean _isUp;
  private boolean _isDown;
  private boolean _isLeft;
  private boolean _isRight;
  
  private float _bounceFactor;

  EmojiPlayer(EmojiWorld world, int id, PVector pos) {
    super(world, id, pos, new PVector());

    _maxVelocity = 4;
    _acceleration = 0.1;

    _acc = new PVector();

    _isUp = false;
    _isDown = false;
    _isLeft = false;
    _isRight = false;
    
    _bounceFactor = 0.8;
  }

  void step() {
    _acc.x = 0;
    _acc.y = 0;

    if (_isUp) {
      _acc.y -= _acceleration;
    }
    if (_isDown) {
      _acc.y += _acceleration;
    }
    if (_isLeft) {
      _acc.x -= _acceleration;
    }
    if (_isRight) {
      _acc.x += _acceleration;
    }

    _vel.add(_acc);
    if (_vel.mag() > _maxVelocity) {
      _vel.mult(_maxVelocity / _vel.mag());
    }
    
    Rectangle b = _group.getBounds();
    if (b.x < 0) {
      _pos.x -= b.x;
      if (_vel.x < 0) {
        _vel.x = -_vel.x * _bounceFactor;
      }
    }
    if (b.x + b.w > world.worldWidth) {
      _pos.x -= b.x + b.w - world.worldWidth;
      if (_vel.x > 0) {
        _vel.x = -_vel.x * _bounceFactor;
      }
    }
    if (b.y < 0) {
      _pos.y -= b.y;
      if (_vel.y < 0) {
        _vel.y = -_vel.y * _bounceFactor;
      }
    }
    if (b.y + b.h > world.worldHeight) {
      _pos.y -= b.y + b.h - world.worldHeight;
      if (_vel.y > 0) {
        _vel.y = -_vel.y * _bounceFactor;
      }
    }

    super.step();
  }

  void keyPressed() {
    switch (keyCode) {
      case UP:
        _isUp = true;
        break;
      case DOWN:
        _isDown = true;
        break;
      case LEFT:
        _isLeft = true;
        break;
      case RIGHT:
        _isRight = true;
        default:
    }
  }

  void keyReleased() {
    switch (keyCode) {
      case UP:
        _isUp = false;
        break;
      case DOWN:
        _isDown = false;
        break;
      case LEFT:
        _isLeft = false;
        break;
      case RIGHT:
        _isRight = false;
        default:
    }
  }
}
