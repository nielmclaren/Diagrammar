
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
    for (int i = 0; i < w * h; i++) {
      float b = brightness(inPixels[i]);
      outPixels[i] = _palette[floor(map(b, 0, 255, 0, _palette.length - 1))];
    }
  }
}
