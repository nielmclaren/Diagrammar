

class EmojiGroup {
  int id;
  EmojiParticle leader;
  ArrayList<EmojiParticle> particles;
  
  EmojiGroup(int identifier, EmojiParticle p) {
    init(identifier, p);
  }
  
  EmojiGroup(int identifier, EmojiParticle p, EmojiParticle q) {
    init(identifier, p);
    particles.add(q);
  }
  
  void init(int identifier, EmojiParticle p) {
    id = identifier;
    leader = p;
    particles = new ArrayList<EmojiParticle>();
    particles.add(p);
  }
  
  void draw(PGraphics g) {
    Rectangle b = getBounds();
    if (b != null) {
      g.rect(b.x, b.y, b.w, b.h);
    }
  }
  
  Rectangle getBounds() {
    Rectangle bounds = null;
    Iterator<EmojiParticle> iter = particles.iterator();
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
    return "[EmojiGroup " + str(id) + "]";
  }
}
