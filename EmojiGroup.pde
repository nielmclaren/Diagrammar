

class EmojiGroup {
  private int _id;
  private EmojiParticle _leader;
  private ArrayList<EmojiParticle> _particles;

  EmojiGroup(int id, EmojiParticle leader) {
    init(id, leader);
  }

  EmojiGroup(int id, EmojiParticle leader, EmojiParticle q) {
    init(id, leader);
    _particles.add(q);
  }

  void init(int id, EmojiParticle leader) {
    _id = id;
    _leader = leader;
    _particles = new ArrayList<EmojiParticle>();
    _particles.add(leader);
  }

  void draw(PGraphics g) {
    Rectangle b = getBounds();
    if (b != null) {
      g.rect(b.x, b.y, b.w, b.h);
    }
  }
  
  EmojiParticle getLeader() {
    return _leader;
  }
  
  void setLeader(EmojiParticle leader) {
    _leader = leader;
  }
  
  PVector getVelocity() {
    return _leader.getVelocity();
  }
  
  boolean isEmpty() {
    return _particles.size() <= 0;
  }
  
  void add(EmojiParticle p) {
    _particles.add(p);
  }
  
  void remove(EmojiParticle p) {
    _particles.remove(p);
  }
  
  Iterator<EmojiParticle> iterator() {
    return _particles.iterator();
  }

  Rectangle getBounds() {
    Rectangle bounds = null;
    Iterator<EmojiParticle> iter = _particles.iterator();
    while (iter.hasNext()) {
      EmojiParticle p = iter.next();
      if (bounds == null) {
        bounds = p.getBounds();
      }
      else {
        bounds = bounds.union(p.getBounds());
      }
    }
    return bounds;
  }

  String toString() {
    return "[EmojiGroup " + str(_id) + "]";
  }
}
