
import java.util.Iterator;

FileNamer fileNamer;
EmojiWorld world;

void setup() {
  size(1024, 768, P3D);
  smooth();
  lights();

  fileNamer = new FileNamer("output/export", "png");
  world = new EmojiWorld(this.g, width, height);
}

void draw() {
  background(0);
  world.draw();
}

void keyPressed() {
  world.keyPressed();
}

void keyReleased() {
  world.keyReleased();
  
  switch (key) {
    case ' ':
      world.reset();
      break;
    case 'r':
      save(fileNamer.next());
      break;
      default:
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

