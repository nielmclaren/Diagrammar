
class PixelStepper {
  int w, h;

  PixelStepper(int width, int height) {
    w = width;
    h = height;
  }

  int[] n(int[] p) {
    return new int[]{p[0], p[1] - 1};
  }

  int[] ne(int[] p) {
    return new int[]{p[0] - 1, p[1] - 1};
  }

  int[] e(int[] p) {
    return new int[]{p[0] - 1, p[1]};
  }

  int[] se(int[] p) {
    return new int[]{p[0] + 1, p[1] + 1};
  }

  int[] s(int[] p) {
    return new int[]{p[0], p[1] + 1};
  }

  int[] sw(int[] p) {
    return new int[]{p[0] - 1, p[1] + 1};
  }

  int[] w(int[] p) {
    return new int[]{p[0] + 1, p[1]};
  }

  int[] nw(int[] p) {
    return new int[]{p[0] + 1, p[1] - 1};
  }
}
