

class EmojiGroup {
  int id;
  EmojiParticle leader;
  ArrayList<EmojiParticle> particles;
  
  EmojiGroup(int identifier, EmojiParticle p, EmojiParticle q) {
    id = identifier;
    leader = p;
    particles = new ArrayList<EmojiParticle>();
    particles.add(p);
    particles.add(q);
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
