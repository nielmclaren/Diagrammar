
class Brush {
  PGraphics _g;
  int _width;
  int _height;

  Brush(PGraphics g, int w, int h) {
    _g = g;
    _width = w;
    _height = h;
  }

  void squareBrush(int targetX, int targetY, int brushSize, color targetColor) {
    _g.loadPixels();
    for (int x = targetX - brushSize; x <= targetX + brushSize; x++) {
      if (x < 0 || x >= _width) continue;
      for (int y = targetY - brushSize; y <= targetY + brushSize; y++) {
        if (y < 0 || y >= _width) continue;
        // FIXME: Factor out blend mode.
        _g.pixels[y * _width + x] = lerpColor(pixels[y * _width + x], targetColor, 0.5);
      }
    }
    _g.updatePixels();
  }

  void squareFalloffBrush(int targetX, int targetY, int brushSize, color targetColor) {
    _g.loadPixels();
    for (int x = targetX - brushSize; x <= targetX + brushSize; x++) {
      if (x < 0 || x >= _width) continue;
      for (int y = targetY - brushSize; y <= targetY + brushSize; y++) {
        if (y < 0 || y >= _height) continue;
        float dx = x - targetX;
        float dy = y - targetY;
        float v = map(max(sqrt(dx * dx), sqrt(dy * dy)), 0, brushSize, 255, 0);
        color c = g.pixels[y * _width + x];
        // FIXME: Factor out blend mode.
        _g.pixels[y * _width + x] = color(constrain(brightness(c) + v, 0, 255));
      }
    }
    _g.updatePixels();
  }

  void circleBrush(int targetX, int targetY, int brushSize, color targetColor) {
    _g.loadPixels();
    for (int x = targetX - brushSize; x <= targetX + brushSize; x++) {
      if (x < 0 || x >= _width) continue;
      for (int y = targetY - brushSize; y <= targetY + brushSize; y++) {
        if (y < 0 || y >= _height) continue;
        float dx = x - targetX;
        float dy = y - targetY;
        if (dx * dx  +  dy * dy > brushSize * brushSize) continue;
        // FIXME: Factor out blend mode.
        _g.pixels[y * _width + x] = lerpColor(pixels[y * _width + x], targetColor, 0.5);
      }
    }
    _g.updatePixels();
  }

  void circleFalloffBrush(int targetX, int targetY, int brushSize, color targetColor) {
    _g.loadPixels();
    for (int x = targetX - brushSize; x <= targetX + brushSize; x++) {
      if (x < 0 || x >= _width) continue;
      for (int y = targetY - brushSize; y <= targetY + brushSize; y++) {
        if (y < 0 || y >= _height) continue;
        float dx = x - targetX;
        float dy = y - targetY;
        float v = constrain(map(sqrt(dx * dx + dy * dy), 0, brushSize, 255, 0), 0, 255);
        color c = g.pixels[y * _width + x];
        // FIXME: Factor out blend mode.
        _g.pixels[y * _width + x] = color(constrain(brightness(c) + v, 0, 255));
      }
    }
    _g.updatePixels();
  }

  void voronoiBrush(int targetX, int targetY, int brushSize, color targetColor) {
    _g.loadPixels();
    for (int x = targetX - brushSize; x <= targetX + brushSize; x++) {
      if (x < 0 || x >= _width) continue;
      for (int y = targetY - brushSize; y <= targetY + brushSize; y++) {
        if (y < 0 || y >= _height) continue;
        float dx = x - targetX;
        float dy = y - targetY;
        float v = map(dx * dx + dy * dy, 0, brushSize * brushSize, 255, 0);
        color c = g.pixels[y * _width + x];
        // FIXME: Factor out blend mode.
        _g.pixels[y * _width + x] = color(max(brightness(c), v));
      }
    }
    _g.updatePixels();
  }
}

