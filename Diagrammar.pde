
import java.util.Iterator;

FileNamer fileNamer;
ArrayList<EmojiParticle> particles;
PImage smilesImg;
float scanScale;
boolean showScan;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");
  smilesImg = loadImage("assets/smiles.png");
  showScan = false;

  reset();
}

void draw() {
}

void reset() {
  particles = new ArrayList<EmojiParticle>();

  smilesImg.loadPixels();

  PVector center = new PVector(width/2, height/2);

  for (int i = 0; i < 1000; i++) {
    float scale = pow(0.9 * i/1000 + 1, -2) * 0.5;
    for (int attempts = 0; attempts < 100; attempts++) {
      PVector pos = new PVector(random(height * 0.4), 0);
      pos.rotate(random(2 * PI));
      pos.add(center);

      EmojiParticle p = new EmojiParticle(
        pos,
        getColor(floor(pos.x), floor(pos.y)),
        scale);

      if (!hitTest(p)) {
        particles.add(p);
        break;
      }
    }
  }
  redraw();
}

void redraw() {
  background(255);

  if (showScan) {
    tint(255);
    image(smilesImg, 0, 0);
  } else {
    Iterator iter = particles.iterator();
    while (iter.hasNext ()) {
      EmojiParticle p = (EmojiParticle) iter.next();
      p.draw(this.g);
    }
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
  case 't':
    showScan = !showScan;
    redraw();
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

color getColor(int x, int y) {
  color bg[] = new color[] {
    color(206, 119, 82),
    color(238, 139, 102),
    color(238, 167, 121)
  };

  color fg[] = new color[] {
    color(41, 173, 122),
    color(23, 172, 124),
    color(141, 186, 128),
    color(195, 190, 123)
  };

  if (brightness(smilesImg.pixels[y * width + x]) < 128) {
    return fg[floor(random(fg.length))];
  }
  else {
    return bg[floor(random(bg.length))];
  }
}

boolean hitTest(EmojiParticle p) {
  for (int i = 0; i < particles.size(); i++) {
    if (particles.get(i).hitTest(p)) {
      return true;
    }
  }
  return false;
}

