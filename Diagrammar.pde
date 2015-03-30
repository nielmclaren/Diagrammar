
import java.util.Iterator;

FileNamer fileNamer;
PImage brainImg;
ArrayList<EmojiParticle> particles;

void setup() {
  size(1024, 768, P3D);
  smooth();
  lights();

  fileNamer = new FileNamer("output/export", "png");
  brainImg = loadImage("assets/brainlandmarks.jpg");

  reset();
}

void draw() {
  image(brainImg, 0, 0);

  Iterator iter = particles.iterator();
  while (iter.hasNext()) {
    EmojiParticle p = (EmojiParticle) iter.next();
    p.draw(this.g);
  }
}

void reset() {
  background(0);

  particles = new ArrayList<EmojiParticle>();

  particles.add(new EmojiParticle(new PVector(259, 69)));
  particles.add(new EmojiParticle(new PVector(498, 37)));
  particles.add(new EmojiParticle(new PVector(739, 71)));
  particles.add(new EmojiParticle(new PVector(912, 190)));
  particles.add(new EmojiParticle(new PVector(975, 388)));
  particles.add(new EmojiParticle(new PVector(977, 469)));
  particles.add(new EmojiParticle(new PVector(978, 574)));
  particles.add(new EmojiParticle(new PVector(587, 708)));
  particles.add(new EmojiParticle(new PVector(457, 641)));
  particles.add(new EmojiParticle(new PVector(56, 373)));
  particles.add(new EmojiParticle(new PVector(152, 195)));
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

