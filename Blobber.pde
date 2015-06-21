
class Blobber {
  private color[] _palette;
  
  Blobber() {
    _palette = new color[2];
    _palette[0] = color(0);
    _palette[1] = color(255);
  }
  
  void setPalette(color[] palette) {
    _palette = palette;
  }
  
  void blob(color[] inPixels, color[] outPixels, int w, int h) {
    int s = 40;
    int adj = 16;
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        int i = y * w + x;
        float b = brightness(inPixels[i]);
        if (x % s < s/2 == y % s < s/2) {
          color c = _palette[floor(map(b, 0, 255, 0, _palette.length - 1))];
          outPixels[i] = color(red(c) + adj, green(c) + adj, blue(c) + adj);
        }
        else {
          outPixels[i] = _palette[floor(map(b, 0, 255, 0, _palette.length - 1))];
        }
      }
    }
  }
}
