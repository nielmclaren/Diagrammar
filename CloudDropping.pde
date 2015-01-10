
class CloudDropping {
  CloudRenderer _cloud;

  CloudDropping(CloudRenderer cloud) {
    _cloud = cloud;
  }

  public void draw(PGraphics g) {
    float x = random(1);
    if (x < 0.25) {
      drawGrid(g);
    }
    else if (x < 0.5) {
      drawSeries(g);
    }
    else if (x < 0.75) {
      drawSingle(g);
    }
    else {
      drawPixelDrip(g);
    }
  }

  private void drawGrid(PGraphics g) {
    PVector offset = new PVector();
    float[][] bounds = _cloud.getBounds();
    float dc = 10, dr = 10;

    float boundsWidth = bounds[1][0] - bounds[0][0];
    float boundsHeight = bounds[1][1] - bounds[0][1];
    float w = floor(boundsWidth * 0.7 / dc) * dc + 5;
    float h = 50 + random(1) * 25;
    float startX = -w / 2;
    float startY = 0;

    g.stroke(128);
    g.strokeWeight(3);
    for (float c = 0; c < w; c += dc) {
      for (float r = 0; r < h; r += dr) {
        g.line(
          offset.x + startX + c,
          offset.y + startY + r,
          offset.x + startX + c - 5,
          offset.y + startY + r + 5);
      }
    }
  }

  private void drawSeries(PGraphics g) {
    PVector offset = new PVector();
    float[][] bounds = _cloud.getBounds();
    float dc = 6;

    float boundsWidth = bounds[1][0] - bounds[0][0];
    float boundsHeight = bounds[1][1] - bounds[0][1];
    float w = floor(boundsWidth * 0.8 / dc) * dc + 5;
    float h = 50 + random(1) * 25;
    float startX = -w / 2;
    float startY = 0;

    g.stroke(128);
    g.strokeWeight(1);
    for (float c = 0; c < w; c += dc) {
      g.line(
        offset.x + startX + c,
        offset.y + startY,
        offset.x + startX + c - 15,
        offset.y + startY + h);
    }
  }

  private void drawSingle(PGraphics g) {
    PVector offset = new PVector();
    float[][] bounds = _cloud.getBounds();

    float boundsWidth = bounds[1][0] - bounds[0][0];
    float boundsHeight = bounds[1][1] - bounds[0][1];
    float w = boundsWidth * 0.8;
    float h = 50 + random(1) * 25;
    float startX = -boundsWidth/2 + (boundsWidth - w) / 2;
    float startY = 0;

    g.noStroke();
    g.fill(236);
    g.rect(offset.x + startX, offset.y + startY, w, h);
  }

  private void drawPixelDrip(PGraphics g) {
    PVector offset = new PVector();
    float[][] bounds = _cloud.getBounds();

    int boundsWidth = floor(bounds[1][0]) - floor(bounds[0][0]);
    int boundsHeight = floor(bounds[1][1]) - floor(bounds[0][1]);

    int w = floor(boundsWidth * 1.25);
    int h = boundsHeight + 150;

    PGraphics cloudCanvas = createGraphics(w, h);
    PGraphics dripCanvas = createGraphics(w, h);
    cloudCanvas.loadPixels();
    dripCanvas.loadPixels();
    for (int i = 0; i < cloudCanvas.pixels.length; i++) {
      cloudCanvas.pixels[i] = color(248);
      dripCanvas.pixels[i] = color(248);
    }
    cloudCanvas.updatePixels();
    dripCanvas.updatePixels();

    cloudCanvas.beginDraw();
    cloudCanvas.pushMatrix();
    cloudCanvas.translate(w/2, boundsHeight/2);
    _cloud.draw(cloudCanvas);
    cloudCanvas.popMatrix();
    cloudCanvas.endDraw();

    pixelDrip(cloudCanvas, dripCanvas, new PixelStepper(w, h), w, h);

    image(dripCanvas,
      floor(bounds[0][0]) - w/2 + boundsWidth/2,
      floor(bounds[0][1]));
  }

  void pixelDrip(PGraphics canvas, PGraphics dripCanvas, PixelStepper stepper, int w, int h) {
    canvas.loadPixels();

    float c;
    int[] p = new int[2];
    for (int i = 0; i < 1000 + random(4000); i++) {
      p[0] = floor(w * (0.2 + random(1) * 0.6));
      p[1] = floor((h - 150) * (0.5 + random(1) * 0.5));
      c = brightness(canvas.pixels[p[1] * w + p[0]]);
      c += 0.4;
      if (c < 64) {
        for (int j = 0; j < 10 + 240 * random(1); j++) {
          if (p[1] % 3 == 0) {
            p = stepper.sw(p);
          }
          else {
            p = stepper.s(p);
          }
          if (p[0] >= 0 && p[0] < w && p[1] >= 0 && p[1] < h) {
            dripCanvas.pixels[p[1] * w + p[0]] = color(floor(c * 255));
          }
        }
      }
    }

    canvas.updatePixels();
  }
}
