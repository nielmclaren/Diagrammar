
import java.util.Iterator;

FileNamer fileNamer;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
  background(0x192c31);
  noFill();
  strokeWeight(2);
  for (int i = 0; i < 5; i++) {
    drawCrystal(new PVector(random(width), random(height)));
  }
}

void draw() {
}

void drawCrystal(PVector point) {
  float baseRadius = random(60, 120);
  drawCrystal(point, 0, 2 * PI, baseRadius);
}

void drawCrystal(PVector point, float direction, float angle, float baseRadius) {
  int numCycles = getNumCycles(baseRadius, angle);
  for (int i = 0; i < numCycles; i++) {
    float dir = direction - angle/2 + angle * i / numCycles + random(2.0 * PI * 0.001);
    drawLine(point, dir, baseRadius + random(baseRadius * 0.02));
  }
  
  for (int i = 0; i < numCycles; i++) {
    if (random(1) < 0.006) {
      float dir = direction - angle/2 + angle * i / numCycles + random(2.0 * PI * 0.001);
      PVector p = new PVector(
        point.x + baseRadius * cos(dir),
        point.y + baseRadius * sin(dir));
      drawCrystal(p, dir + 2 * PI * random(-0.1, 0.1), angle * random(0.05, 0.2), baseRadius * random(0.4, 0.8));
    }
  }
}

void drawLine(PVector p, float direction, float radius) {
  float noiseScale = 0.01;
  
  float x = p.x + radius * cos(direction);
  float y = p.y + radius * sin(direction);
  float colorJitter = 0.1;
  color c1 = lerpColor(#29415a, #818b95, noise(x * noiseScale, y * noiseScale) + random(colorJitter));
  color c2 = lerpColor(#29415a, #818b95, noise(x * noiseScale, y * noiseScale) + random(colorJitter));
  
  x = p.x;
  y = p.y;
  int numSegments = floor(random(5, 12));
  for (int i = 0; i < numSegments; i++) {
    float r = radius / numSegments;
    x += r * cos(direction);
    y += r * sin(direction);
    stroke(lerpColor(c1, c2, random(1)));
    line(p.x, p.y, x, y);
  }
}

int getNumCycles(float r, float a) {
  return floor(a * r * 0.7);
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

