
import java.util.Collections;
import java.util.Iterator;

FileNamer fileNamer;

int currDirection;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  currDirection = 1;

  reset();
}

void reset() {
  background(0);

  stroke(#cdddff);
  fill(#444a91);
}

void draw() {
}

void drawWave(int direction) {
  for (int i = 0; i < 20; i++) {
    translate(direction * 10 + jitter(), 5 + jitter());
    drawDiamond();
  }
}

void drawDiamond() {
  pushMatrix();
  scale(1, 0.6);
  rotate(PI/4 + (random(1) - 0.5) * 0.05);
  rect(0, 0, 250, 250, 20);
  popMatrix();
}

float jitter() {
  return (random(1) - 0.5) * 6;
}

void keyReleased() {
  switch (key) {
    case ' ':
      reset();
      break;
    case 'r':
      save(fileNamer.next());
      break;
    case 'k':
      currDirection = currDirection < 0 ? 1 : -1;
      break;
  }
}

void mousePressed() {
}

void mouseReleased() {
  pushMatrix();
  translate(mouseX, mouseY);
  drawWave(currDirection);
  popMatrix();
}

void mouseDragged() {
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}

