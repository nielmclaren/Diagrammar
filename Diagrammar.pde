
FileNamer fileNamer;
ArrayList<VectorStepper> steppers;

PGraphics fillCanvas, strokeCanvas;

color[] palette;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");

  palette = loadPalette("assets/layers.jpg");

  reset();
}

void reset() {
  background(#e698ec);

  steppers = new ArrayList<VectorStepper>();
  steppers.add(getStepper(new PVector(width/2, height/2)));

  for (int i = 0; i < steppers.size(); i++) {
    VectorStepper stepper = steppers.get(i);
    int steps = floor(random(100, 200));

    fillCanvas = createGraphics(width, height);
    strokeCanvas = createGraphics(width, height);

    strokeCanvas.beginDraw();
    fillCanvas.beginDraw();

    strokeCanvas.noStroke();
    strokeCanvas.fill(0);
    fillCanvas.noStroke();
    fillCanvas.fill(palette[i % palette.length]);

    drawSteps(stepper, steps);

    strokeCanvas.endDraw();
    fillCanvas.endDraw();

    image(strokeCanvas, 0, 0);
    image(fillCanvas, 0, 0);
  }
}

void draw() {
}

color[] loadPalette(String paletteFilename) {
  PImage paletteImg = loadImage(paletteFilename);
  color[] palette = new color[paletteImg.width];
  paletteImg.loadPixels();
  for (int i = 0; i < paletteImg.width; i++) {
    palette[i] = paletteImg.pixels[i];
  }
  return palette;
}

VectorStepper getStepper(PVector point) {
  float posDelta = 3;
  float angleDelta = random(0.05, 0.15) * PI;
  return new VectorStepper(point, posDelta, posDelta, angleDelta, angleDelta);
}

void drawSteps(VectorStepper stepper, int steps) {
  float strokeRadius = stepper.getMinPosDelta() + random(5, 20);
  float fillRadius = strokeRadius * 0.8;

  for (int i = 0; i < steps; i++) {
    PVector p = stepper.next();
    strokeCanvas.ellipse(p.x, p.y, strokeRadius, strokeRadius);
    fillCanvas.ellipse(p.x, p.y, fillRadius, fillRadius);

    if (random(1) < 0.05 && steppers.size() < 100) {
      steppers.add(getStepper(p));
    }

    if (random(1) < 0.02) {
      VectorStepper tentacleStepper = new VectorStepper(
        p,
        new PVector(0, 1),
        1, 1, 0, 0.04 * PI);
      drawTentacleSteps(tentacleStepper, floor(random(80, 240)), fillRadius);
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
    PVector p = stepper.next();
    strokeCanvas.ellipse(p.x, p.y, strokeRadius, strokeRadius);
    fillCanvas.ellipse(p.x, p.y, fillRadius, fillRadius);

    strokeRadius *= 0.992;
    fillRadius = strokeRadius * 0.6;
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

