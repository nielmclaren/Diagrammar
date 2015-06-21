
import java.util.Iterator;

FileNamer fileNamer;
PGraphics gradientImg, blobImg, crystalImg;
color[] palette;
FastBlurrer blurrer;

void setup() {
  size(1024, 768);
  background(128);
  smooth();

  fileNamer = new FileNamer("output/export", "png");
  
  gradientImg = createGraphics(width, height);
  blobImg = createGraphics(width, height);
  crystalImg = createGraphics(width, height);
  blurrer = new FastBlurrer(gradientImg.width, gradientImg.height, 5);
  
  loadPalette("assets/stripey.png");

  reset();
}

void reset() {
  gradientImg.loadPixels();
  crystalImg.loadPixels();
  
  for (int i = 0; i < width * height; i++) {
    gradientImg.pixels[i] = color(0);
    crystalImg.pixels[i] = color(0, 0);
  }
  gradientImg.updatePixels();
  crystalImg.updatePixels();
  
  gradientImg.beginDraw();
  crystalImg.beginDraw();
  
  crystalImg.noFill();
  crystalImg.strokeWeight(2);
  
  for (int i = 0; i < 5; i++) {
    drawCrystal(new PVector(random(width), random(height)), random(60, 120));
  }
  
  gradientImg.endDraw();
  crystalImg.endDraw();
  
  gradientImg.loadPixels();
  blurrer.blur(gradientImg.pixels);
  gradientImg.updatePixels();
  
  updateBlobImg();
  
  image(blobImg, 0, 0);
  image(crystalImg, 0, 0);
}

void updateBlobImg() {
  gradientImg.loadPixels();
  blobImg.loadPixels();
  
  for (int i = 0; i < blobImg.width * blobImg.height; i++) {
    float b = brightness(gradientImg.pixels[i]);
    blobImg.pixels[i] = palette[floor(map(b, 0, 255, 0, palette.length - 1))];
  }
  
  blobImg.updatePixels();
}

void draw() {
}

void drawCrystal(PVector point, float baseRadius) {
  drawCrystal(point, 0, 2 * PI, baseRadius);
}

void drawCrystal(PVector point, float direction, float angle, float baseRadius) {
  int numCycles = getNumCycles(baseRadius, angle);
  float radius = 0;
  for (int i = 0; i < numCycles; i++) {
    float dir = direction - angle/2 + angle * i / numCycles + random(2.0 * PI * 0.001);
    if (i % 12 == 0) {
      radius = baseRadius + random(baseRadius * 0.04);
    }
    drawLine(point, dir, radius);
  }
  
  for (int i = 0; i < numCycles; i++) {
    float dir = direction - angle/2 + angle * i / numCycles + random(2.0 * PI * 0.001);
    if (random(1) < 0.006) {
      PVector p = new PVector(
        point.x + baseRadius * cos(dir),
        point.y + baseRadius * sin(dir));
      drawCrystal(p, dir + 2 * PI * random(-0.1, 0.1), angle * random(0.05, 0.2), baseRadius * random(0.4, 0.8));
    }
    
    if (random(1) < 0.016) {
      radius = baseRadius + random(8, 16);
      drawCrystal(new PVector(
        point.x + radius * cos(dir),
        point.y + radius * sin(dir)), random(2 * PI), 2 * PI * random(0.02, 0.12), baseRadius * random(0.06, 0.12));
    }
  }
}

void drawLine(PVector p, float direction, float radius) {
  float noiseScale = 0.01;
  
  float x = p.x + radius * cos(direction);
  float y = p.y + radius * sin(direction);
  float colorJitter = 0.1;
  color c1 = lerpColor(#ff9b17, #ffc617, noise(x * noiseScale, y * noiseScale) + random(colorJitter));
  color c2 = lerpColor(#ff9b17, #f8ad4a, noise(x * noiseScale, y * noiseScale) + random(colorJitter));
  
  x = p.x;
  y = p.y;
  int numSegments = floor(random(5, 12));
  for (int i = 0; i < numSegments; i++) {
    float r = radius / numSegments;
    x += r * cos(direction);
    y += r * sin(direction);
    crystalImg.stroke(lerpColor(c1, c2, random(1)));
    crystalImg.line(p.x, p.y, x, y);
    
    gradientImg.blendMode(ADD);
    gradientImg.strokeWeight(16);
    gradientImg.stroke(128);
    gradientImg.line(p.x, p.y, x, y);
  }
}

int getNumCycles(float r, float a) {
  return floor(a * r * 1.2);
}

void loadPalette(String paletteFilename) {
  PImage paletteImg = loadImage(paletteFilename);
  palette = new color[paletteImg.width];
  paletteImg.loadPixels();
  for (int i = 0; i < paletteImg.width; i++) {
    palette[i] = paletteImg.pixels[i];
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

