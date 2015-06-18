
import java.util.Iterator;

FileNamer fileNamer;
EmojiWorld world;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");
  world = new EmojiWorld(2 * width, 2 * height, 160);
}

void draw() {
  background(0);
  world.step();
  
  pushMatrix();
  PVector offset = world.getOffset();
  translate(width/2 - offset.x, height/2 - offset.y);
  world.draw(this.g);
  popMatrix();
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
    case 'p':
      world.setPaused(!world.isPaused());
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

