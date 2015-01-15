
class Particle {
  PVector _position;
  PVector _velocity;
  color _color;
  
  float _friction;
  int _age;
  float _noiseSeed;
  float _noiseScale;
  
  PVector _vector;

  Particle(PVector pos, PVector vel, color c) {
    _position = pos.get();
    _velocity = vel.get();
    _color = c;
    
    _friction = 0.06;
    _age = 0;
    _noiseSeed = random(100);
    _noiseScale = 0.05;
    
    _vector = new PVector();
  }

  void step() {
    float n = noise((_noiseSeed + _age) * _noiseScale);
    
    _vector.set(_velocity);
    _vector.normalize();
    _vector.mult((2 * n - 1) * pow(_velocity.mag(), 0.15) * 0.1);
    _vector.rotate(PI/2);
    _velocity.add(_vector);
    
    _vector.set(_velocity);
    _vector.mult(-_friction);
    _velocity.add(_vector);
    
    _position.add(_velocity);
    
    _age++;
  }

  void draw(PGraphics g) {
    g.noStroke();
    g.fill(_color);
    g.ellipse(_position.x, _position.y, 4, 4);
    /*
    g.stroke(255, 0, 0);
    g.strokeWeight(2);
    g.line(_position.x, _position.y, _position.x + _velocity.x * 50, _position.y + _velocity.y * 50);
    //*/
    /*
    g.stroke(0, 0, 255);
    g.strokeWeight(2);
    g.line(_position.x, _position.y, _position.x + _vector.x * 50, _position.y + _vector.y * 50);
    //*/
    /*
    g.stroke(255);
    g.strokeWeight(2);
    g.line(_position.x, _position.y, _position.x + _velocity.x * 50 + _vector.x * 50, _position.y + _velocity.y * 50 + _vector.y * 50);
    //*/
  }
  
  boolean isActive() {
    return _velocity.mag() > 0.1;
  }
  
  int whatsMyAgeAgain() {
    return _age;
  }
}
