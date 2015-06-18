
class EmojiWorld {
  int worldWidth;
  int worldHeight;
  private int _gridSize;
  private int _numCols;
  private int _numRows;
  private boolean _isPaused;

  private int _numParticles;
  private ArrayList<EmojiParticle> _particles;
  private ArrayList<EmojiGroup> _groups;
  private int _currGroupIndex;
  private EmojiPlayer _player;
  private EmojiGroup _playerGroup;

  EmojiWorld(int w, int h, int numParticles) {
    worldWidth = w;
    worldHeight = h;

    _gridSize = 20;
    _numCols = ceil(worldWidth / 20);
    _numRows = ceil(worldHeight / 20);

    worldWidth = _numCols * _gridSize;
    worldHeight = _numRows * _gridSize;

    _isPaused = false;
    _numParticles = numParticles;

    reset();
  }

  void reset() {
    _particles = new ArrayList<EmojiParticle>();
    _groups = new ArrayList<EmojiGroup>();
    _currGroupIndex = 0;

    _player = new EmojiPlayer(this, 0, new PVector(worldWidth/2, worldHeight/2));
    _playerGroup = new EmojiGroup(_currGroupIndex++, _player);
    _player.group = _playerGroup;
    _particles.add(_player);

    for (int i = 1; i < _numParticles; ++i) {
      _particles.add(place(new EmojiParticle(this, i)));
    }
  }

  void step() {
    if (_isPaused) return;

    Iterator<EmojiParticle> iter;

    for (int i = 0; i < _groups.size(); i++) {
      EmojiGroup group = _groups.get(i);
      if (group.isEmpty()) {
        _groups.remove(i);
        i--;
      }
    }

    for (int i = 1; i < _particles.size(); i++) {
      EmojiParticle p = _particles.get(i);
      if (!p.visible() && (p.group == null || p.group.getLeader() != _player)) {
        if (p.group != null) {
          p.group.remove(p);
        }
        _particles.set(i, place(new EmojiParticle(this, i)));
        i--;
      }
    }

    stepPlayerGroup();

    iter = _particles.iterator();
    while (iter.hasNext()) {
      EmojiParticle p = iter.next();
      p.step();
    }

    for (int i = 0; i < _particles.size () - 1; i++) {
      EmojiParticle p = _particles.get(i);
      for (int j = i + 1; j < _particles.size (); j++) {
        EmojiParticle q = _particles.get(j);
        if (p.collision(q)) {
          handleCollision(p, q);
        }
      }
    }
  }

  void stepPlayerGroup() {
    Rectangle b = _playerGroup.getBounds();
    if (b.x < 0) {
      _player.pos.x -= b.x;
      if (_player.vel.x < 0) {
        _player.vel.x = -_player.vel.x;
      }
    }
    if (b.x + b.w > world.worldWidth) {
      _player.pos.x -= b.x + b.w - world.worldWidth;
      if (_player.vel.x > 0) {
        _player.vel.x = -_player.vel.x;
      }
    }
    if (b.y < 0) {
      _player.pos.y -= b.y;
      if (_player.vel.y < 0) {
        _player.vel.y = -_player.vel.y;
      }
    }
    if (b.y + b.h > world.worldHeight) {
      _player.pos.y -= b.y + b.h - world.worldHeight;
      if (_player.vel.y > 0) {
        _player.vel.y = -_player.vel.y;
      }
    }
  }

  void draw(PGraphics g) {
    g.background(255);

    g.noFill();
    g.stroke(224);
    g.strokeWeight(1);
    drawGrid(g);

    g.strokeWeight(4);
    g.rect(0, 0, worldWidth, worldHeight);

    Iterator<EmojiParticle> iter = _particles.iterator();
    while (iter.hasNext()) {
      EmojiParticle p = iter.next();
      p.draw(g);
    }
  }
  
  PVector getOffset() {
    return _player.pos.get();
  }
  
  boolean isPaused() {
    return _isPaused;
  }
  
  void setPaused(boolean paused) {
    _isPaused = paused;
  }

  private void drawGrid(PGraphics g) {
    for (int c = 0; c <= _numCols; c++) {
      g.line(c * _gridSize, 0, c * _gridSize, worldHeight);
    }
    for (int r = 0; r <= _numRows; r++) {
      g.line(0, r * _gridSize, worldWidth, r * _gridSize);
    }
  }

  private EmojiParticle place(EmojiParticle p) {
    while (dist (_player.pos.x, _player.pos.y, p.pos.x, p.pos.y) < 250 || collision(p)) {
      p.pos.x = random(width);
      p.pos.y = random(height);
    }
    return p;
  }

  private boolean collision(EmojiParticle p) {
    Iterator<EmojiParticle> iter = _particles.iterator();
    while (iter.hasNext ()) {
      EmojiParticle q = iter.next();
      if (p.id != q.id && p.collision(q)) {
        return true;
      }
    }
    return false;
  }

  private void handleCollision(EmojiParticle p, EmojiParticle q) {
    if (p.group == null) {
      if (q.group == null) {
        p.group = q.group = new EmojiGroup(_currGroupIndex++, p, q);
        _groups.add(p.group);
      }
      else {
        q.group.add(p);
        p.group = q.group;
      }
    } else {
      if (q.group == null) {
        p.group.add(q);
        q.group = p.group;
      } else if (p.group != q.group) {
        if (q.group == _playerGroup) {
          EmojiParticle temp = p;
          p = q;
          q = temp;
        }

        Iterator<EmojiParticle> iter = q.group.iterator();
        int i = 0;
        while (iter.hasNext()) {
          EmojiParticle r = iter.next();
          _groups.remove(r.group);
          r.group = p.group;
          p.group.add(r);
        }
      }
    }

    if (p == _player) p.group.setLeader(p);
    else if (q == _player) p.group.setLeader(q);
  }

  void keyPressed() {
    _player.keyPressed();
  }

  void keyReleased() {
    _player.keyReleased();
  }
}

