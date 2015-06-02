

FileNamer fileNamer;

int X_AXIS = 1;
int Y_AXIS = 2;
color black;
color white;

void setup() {
  size(640, 480);
  smooth();

  fileNamer = new FileNamer("output/export", "png");
  
  black = color(0);
  white = color(255);

  reset(5);
}

void draw() {
}

void reset(int count) {
  background(0);
  noStroke();
  float h = (float)height/count;
  for (int i = 0; i < count; i++) {
    if (i % 2 == 0) {
      setGradient(0, floor(i * h), width, h, black, white, X_AXIS);
    }
    else {
      setGradient(0, floor(i * h), width, h, white, black, X_AXIS);
    }
  }
}

void keyReleased() {
  switch (key) {
    case ' ':
      reset(randi(3, 15));
      break;
    case 'r':
      for (int i = 3; i < 15; i++) {
        reset(i);
        save("output/altx_gradient_rows_" + i + ".png");
      }
      reset(5);
      save("render.png");
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

/**
 * Straight out of Processing.org example.
 * @see https://processing.org/examples/lineargradient.html
 */
void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
