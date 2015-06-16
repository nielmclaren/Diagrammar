
class EmojiWorld {
  int worldWidth;
  int worldHeight;
  int gridSize;
  int numCols;
  int numRows;
  boolean isPaused;

  int minParticles;
  ArrayList<EmojiParticle> particles;
  ArrayList<EmojiGroup> groups;
  int currGroupIndex;
  EmojiPlayer player;

  EmojiWorld(int w, int h) {
    worldWidth = w;
    worldHeight = h;
    
    gridSize = 20;
    numCols = ceil(worldWidth / 20);
    numRows = ceil(worldHeight / 20);
    
    worldWidth = numCols * gridSize;
    worldHeight = numRows * gridSize;

    isPaused = false;
    minParticles = 160;

    reset();
  }

  void reset() {
    particles = new ArrayList<EmojiParticle>();
    groups = new ArrayList<EmojiGroup>();

    player = new EmojiPlayer(this, 0, new PVector(worldWidth/2, worldHeight/2));
    particles.add(player);

    for (int i = 1; i < minParticles; ++i) {
      particles.add(place(new EmojiParticle(this, i)));
    }
    currGroupIndex = 0;
  }
  
  void step() {
    if (isPaused) return;
    
    Iterator<EmojiParticle> iter;
    
    for (int i = 0; i < groups.size(); i++) {
      EmojiGroup group = groups.get(i);
      if (group.particles.size() <= 0) {
        groups.remove(i);
        i--;
      }
    }

    for (int i = 1; i < particles.size(); i++) {
      EmojiParticle p = particles.get(i);
      if (!p.visible() && (p.group == null || p.group.leader != player)) {
        if (p.group != null) {
          p.group.particles.remove(p);
        }
        particles.set(i, place(new EmojiParticle(this, i)));
        i--;
      }
    }

    iter = particles.iterator();
    while (iter.hasNext()) {
      EmojiParticle p = iter.next();
      p.step();
    }

    for (int i = 0; i < particles.size () - 1; i++) {
      EmojiParticle p = particles.get(i);
      for (int j = i + 1; j < particles.size (); j++) {
        EmojiParticle q = particles.get(j);
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

    Iterator<EmojiParticle> iter = particles.iterator();
    while (iter.hasNext()) {
      EmojiParticle p = iter.next();
      p.draw(g);
    }
    
    g.noFill();
    g.stroke(255, 128, 128);
    g.strokeWeight(4);
    Iterator<EmojiGroup> groupIter = groups.iterator();
    while (groupIter.hasNext()) {
      EmojiGroup group = groupIter.next();
      group.draw(g);
    }
  }
  
  void drawGrid(PGraphics g) {
    for (int c = 0; c <= numCols; c++) {
      g.line(c * gridSize, 0, c * gridSize, worldHeight);
    }
    for (int r = 0; r <= numRows; r++) {
      g.line(0, r * gridSize, worldWidth, r * gridSize);
    }
  }

  EmojiParticle place(EmojiParticle p) {
    while (dist (player.pos.x, player.pos.y, p.pos.x, p.pos.y) < 250 || collision(p)) {
      p.pos.x = random(width);
      p.pos.y = random(height);
    }
    return p;
  }

  boolean collision(EmojiParticle p) {
    Iterator<EmojiParticle> iter = particles.iterator();
    while (iter.hasNext ()) {
      EmojiParticle q = iter.next();
      if (p.id != q.id && p.collision(q)) {
        return true;
      }
    }
    return false;
  }

  void handleCollision(EmojiParticle p, EmojiParticle q) {
    if (p.group == null) {
      if (q.group == null) {
        p.group = q.group = new EmojiGroup(currGroupIndex++, p, q);
        groups.add(p.group);
      } else {
        q.group.particles.add(p);
        p.group = q.group;
      }
    } else {
      if (q.group == null) {
        p.group.particles.add(q);
        q.group = p.group;
      } else if (p.group.id != q.group.id) {
        Iterator<EmojiParticle> iter = q.group.particles.iterator();
        int i = 0;
        while (iter.hasNext ()) {
          EmojiParticle r = iter.next();
          groups.remove(r.group);
          r.group = p.group;
          p.group.particles.add(r);
        }
      }
    }

    if (p == player) p.group.leader = p;
    else if (q == player) p.group.leader = q;
  }

  void keyPressed() {
    player.keyPressed();
  }

  void keyReleased() {
    player.keyReleased();
  }
}

