
BezierCurve curve;

ArrayList<Integer> colors;

void setup() {
  size(800, 600);
  frameRate(10);

  curve = new BezierCurve();

  colors = new ArrayList<Integer>();
  colors.add(color(227, 186, 34));
  colors.add(color(242, 218, 87));
  colors.add(color(230, 132, 42));
  colors.add(color(246, 182, 86));
  colors.add(color(19, 123, 128));
  colors.add(color(66, 165, 179));
  colors.add(color(142, 109, 138));
  colors.add(color(179, 150, 173));

  redraw();
}

void draw() {
}

void redraw() {
  background(255);

  curve = new BezierCurve();

  LineSegment line;

  int numSegments = 12;
  for (int i = 0; i < numSegments; i++) {
    line = new LineSegment(
      width/4 + random(1) * width/2,
      height/4 + random(1) * height/2,
      width/4 + random(1) * width/2,
      height/4 + random(1) * height/2);
    curve.addControl(line);
  }

  noStroke();

  float len = curve.getLength();
  float dist = 0;
  while (dist < len) {
    float radius = 3 + random(1) * 12;
    dist += radius;
    if (dist > len) break;
    PVector p = curve.getPointOnCurve(dist / len);

    fill((color)(Integer) colors.get(floor(colors.size() * random(1))));
    ellipse(p.x, p.y, 2 * radius, 2 * radius);

    dist += radius;
  }
}

void keyReleased() {
  switch (key) {
    case ' ':
      redraw();
      break;

    case 'r':
      save("render.png");
      break;
  }
}
