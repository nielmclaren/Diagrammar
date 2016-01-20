
import java.util.Collections;
import java.util.Iterator;

FileNamer fileNamer;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void clear() {
}

void reset() {
  clear();
  redraw();
}

void redraw() {
  background(0);
}

void draw() {
}

void keyReleased() {
  switch (key) {
    case 'c':
      clear();
      redraw();
      break;
    case ' ':
      reset();
      redraw();
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
