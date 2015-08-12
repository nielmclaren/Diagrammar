
import java.util.Collections;
import java.util.Iterator;

FileNamer fileNamer;

PGraphics fillCanvas, strokeCanvas;
PImage img;
PGraphics[] fillLayers, strokeLayers;
PVector center;

color[] palette;

float noiseScale;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  img = loadImage("assets/shuttleapproach.gif");
  center = new PVector(width/2, height/2);

  palette = getColors(img);
  fillLayers = processFillLayers(getLayers(palette));
  strokeLayers = processStrokeLayers(getLayers(palette));

  noiseScale = 0.02;

  reset();
}

void reset() {
  background(0);

  for (int i = 0; i < fillLayers.length; i++) {
    PGraphics fillLayer = fillLayers[i];
    PGraphics strokeLayer = strokeLayers[i];

    fillCanvas = createGraphics(width, height);
    strokeCanvas = createGraphics(width, height);

    strokeCanvas.beginDraw();
    fillCanvas.beginDraw();

    img.loadPixels();
    for (int j = 0; j < 50; j++) {
      PVector p = new PVector(random(width), random(height));
      while (img.get(floor(p.x), floor(p.y)) != palette[i]) {
        p = new PVector(random(width), random(height));
      }

      VectorStepper stepper = getStepper(p);
      int steps = floor(random(100, 200));

      strokeCanvas.noStroke();
      strokeCanvas.fill(0);
      fillCanvas.noStroke();
      fillCanvas.fill(img.get(floor(p.x), floor(p.y)));

      drawSteps(stepper, steps);
    }

    strokeCanvas.endDraw();
    fillCanvas.endDraw();

    image(strokeLayer, 0, 0);
    image(strokeCanvas, 0, 0);
    image(fillLayer, 0, 0);
    image(fillCanvas, 0, 0);
  }
}

void draw() {
}

color[] getColors(PImage img) {
  ArrayList<Integer> colorList = new ArrayList<Integer>();

  img.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    Integer c = img.pixels[i];
    if (!colorList.contains(c)) {
      colorList.add(c);
    }
  }

  color darkest = color(255);
  int darkestIndex = -1;
  for (int i = 0; i < colorList.size(); i++) {
    if (brightness(colorList.get(i)) < brightness(darkest)) {
      darkest = colorList.get(i);
      darkestIndex = i;
    }
  }
  if (darkestIndex >= 0) {
    colorList.remove(darkestIndex);
  }

  Collections.sort(colorList);

  color[] result = new color[colorList.size()];
  Iterator<Integer> iterator = colorList.iterator();
  for (int i = 0; i < result.length; i++) {
    result[i] = iterator.next().intValue();
  }
  return result;
}

PGraphics[] getLayers(color[] colors) {
  img.loadPixels();

  PGraphics[] result = new PGraphics[colors.length];
  for (int i = 0; i < colors.length; i++) {
    color c = colors[i];

    PGraphics r = result[i] = createGraphics(width, height);
    r.loadPixels();
    for (int p = 0; p < img.pixels.length; p++) {
      r.pixels[p] = img.pixels[p] == c ? c : 0;
    }
    r.updatePixels();
  }
  return result;
}

PGraphics[] processFillLayers(PGraphics[] layers) {
  FastBlurrer blurrer = new FastBlurrer(width, height, 1);
  for (int i = 0; i < layers.length; i++) {
    layers[i].loadPixels();
    blurrer.blur(layers[i].pixels);

    for (int p = 0; p < layers[i].pixels.length; p++) {
      color c = layers[i].pixels[p];
      layers[i].pixels[p] = c == palette[i] ? c : 0;
    }

    layers[i].updatePixels();
  }
  return layers;
}

PGraphics[] processStrokeLayers(PGraphics[] layers) {
  color black = color(0);
  FastBlurrer blurrer = new FastBlurrer(width, height, 1);
  for (int i = 0; i < layers.length; i++) {
    layers[i].loadPixels();
    blurrer.blur(layers[i].pixels);

    for (int p = 0; p < layers[i].pixels.length; p++) {
      color c = layers[i].pixels[p];
      layers[i].pixels[p] = c == black ? 0 : black;
    }

    layers[i].updatePixels();
  }
  return layers;
}

VectorStepper getStepper(PVector p) {
  float posDelta = 3;
  float angleDelta = random(0.05, 0.15) * PI;
  PVector dir = p.get();
  dir.sub(center);
  dir.normalize();
  return new VectorStepper(p, dir, posDelta, posDelta, angleDelta, angleDelta);
}

void drawSteps(VectorStepper stepper, int steps) {
  float strokeRadius = stepper.getMinPosDelta() + random(2, 10);
  float fillRadius = strokeRadius * 0.6;

  for (int i = 0; i < steps; i++) {
    PVector p = stepper.next();
    strokeCanvas.ellipse(p.x, p.y, strokeRadius, strokeRadius);
    fillCanvas.ellipse(p.x, p.y, fillRadius, fillRadius);

    if (random(1) < 0.08) {
      PVector dir = p.get();
      dir.sub(center);
      dir.normalize();
      VectorStepper tentacleStepper = new VectorStepper(
        p, dir,
        1, 1, 0, 0.04 * PI);
      drawTentacleSteps(tentacleStepper, floor(random(40, 120)), strokeRadius);
    }
  }
}

void drawTentacleSteps(VectorStepper stepper, int steps, float radius) {
  float radiusDecay = 0.992;

  float strokeRadius = random(radius * 0.5, radius);
  for (int i = 0; i < 240 - steps; i++) {
    strokeRadius *= radiusDecay;
  }
  float fillRadius = strokeRadius * 0.6;

  for (int i = 0; i < steps; i++) {
    PVector q = stepper.getPosition();
    PVector r = stepper.next();
    PVector p = getPerlinPosition(q, r, i, steps);
    stepper.setPosition(p);

    strokeCanvas.ellipse(p.x, p.y, strokeRadius, strokeRadius);
    fillCanvas.ellipse(p.x, p.y, fillRadius, fillRadius);

    strokeRadius *= 0.992;
    fillRadius = strokeRadius * 0.6;
  }
}

PVector getPerlinPosition(PVector curr, PVector next, int i, int steps) {
  float scale = (float)i / steps;

  PVector delta = next.get();
  delta.sub(curr);

  PVector perlinDelta = (new PVector(delta.mag(), 0));
  perlinDelta.rotate(noise(curr.x * noiseScale, curr.y * noiseScale) * PI);

  delta.mult(1 - scale);
  perlinDelta.mult(scale);

  PVector p = curr.get();
  p.add(delta);
  p.add(perlinDelta);

  return p;
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

