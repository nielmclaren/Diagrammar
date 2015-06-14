

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
  
  String toString() {
    return "[EmojiGroup " + str(id) + "]";
  }
}
