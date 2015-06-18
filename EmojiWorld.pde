
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
    _player.setGroup(_playerGroup);
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
      EmojiGroup pg = p.getGroup();
      if (!p.visible() && (pg == null || pg.getLeader() != _player)) {
        if (pg != null) {
          pg.remove(p);
        }
        _particles.set(i, place(new EmojiParticle(this, i)));
        i--;
      }
    }

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
    return _player.getPosition();
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
    PVector pos, playerPos = _player.getPosition();
    do {
      pos = new PVector(random(worldWidth), random(worldHeight));
      p.setPosition(pos);
    }
    while (dist(playerPos.x, playerPos.y, pos.x, pos.y) < 250 || collision(p));
    return p;
  }

  private boolean collision(EmojiParticle p) {
    Iterator<EmojiParticle> iter = _particles.iterator();
    while (iter.hasNext ()) {
      EmojiParticle q = iter.next();
      if (p != q && p.collision(q)) {
        return true;
      }
    }
    return false;
  }

  private void handleCollision(EmojiParticle p, EmojiParticle q) {
    EmojiGroup pg = p.getGroup();
    EmojiGroup qg = q.getGroup();
    if (pg == null) {
      if (qg == null) {
        EmojiGroup group = new EmojiGroup(_currGroupIndex++, p, q);
        _groups.add(group);
        p.setGroup(group);
        q.setGroup(group);
        pg = group;
        qg = group;
      }
      else {
        qg.add(p);
        p.setGroup(qg);
        pg = qg;
      }
    } else {
      if (qg == null) {
        pg.add(q);
        q.setGroup(pg);
        qg = pg;
      } else if (pg != qg) {
        if (qg == _playerGroup) {
          EmojiParticle temp = p;
          p = q;
          q = temp;
          pg = p.getGroup();
          qg = q.getGroup();
        }

        Iterator<EmojiParticle> iter = qg.iterator();
        int i = 0;
        while (iter.hasNext()) {
          EmojiParticle r = iter.next();
          _groups.remove(r.getGroup());
          r.setGroup(pg);
          pg.add(r);
        }
      }
    }

    if (p == _player) p.getGroup().setLeader(p);
    else if (q == _player) p.getGroup().setLeader(q);
  }

  void keyPressed() {
    _player.keyPressed();
  }

  void keyReleased() {
    _player.keyReleased();
  }
}

