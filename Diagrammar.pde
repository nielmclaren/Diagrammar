
import java.util.Iterator;

FileNamer fileNamer;
ArrayList<EmojiParticle> particles;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void draw() {
  Iterator iter = particles.iterator();
  while (iter.hasNext()) {
    EmojiParticle p = (EmojiParticle) iter.next();
    p.step();
    p.draw(this.g);
  }
}

void reset() {
  background(0);

  particles = new ArrayList<EmojiParticle>();

  for (int i = 0; i < 300; i++) {
    EmojiParticle p = new EmojiParticle(
      new PVector(random(width), random(height)));
    particles.add(p);
  }
}

void keyReleased() {
  switch (key) {
    case ' ':
      reset();
      break;
    case 'r':
      save(fileNamer.next());
      break;
  }
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseDragged() {
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}

