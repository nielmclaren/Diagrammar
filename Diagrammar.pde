
import java.util.Iterator;

FileNamer fileNamer;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void draw() {
}

void drawCrystal(PVector p) {
  noFill();
  strokeWeight(2);
  
  int numCycles = 400;
  for (int i = 0; i < numCycles; i++) {
    drawLine(p, i, numCycles);
  }
}

void drawLine(PVector p, int index, int numCycles) {
  float noiseScale = 0.01;
  
  float radius = 80 + random(3);
  float theta = 2.0 * PI * index / numCycles + random(2.0 * PI * 0.001);
  float x = p.x + radius * cos(theta);
  float y = p.y + radius * sin(theta);
  float colorJitter = 0.1;
  color c1 = lerpColor(#29415a, #818b95, noise(x * noiseScale, y * noiseScale) + random(colorJitter));
  color c2 = lerpColor(#29415a, #818b95, noise(x * noiseScale, y * noiseScale) + random(colorJitter));
  
  x = p.x;
  y = p.y;
  int numSegments = floor(random(5, 12));
  for (int i = 0; i < numSegments; i++) {
    float r = radius / numSegments;
    x += r * cos(theta);
    y += r * sin(theta);
    stroke(lerpColor(c1, c2, random(1)));
    line(p.x, p.y, x, y);
  }
}

void reset() {
  background(0x192c31);
  for (int i = 0; i < 20; i++) {
    drawCrystal(new PVector(random(width), random(height)));
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

