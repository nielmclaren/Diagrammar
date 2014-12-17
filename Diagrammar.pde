
BezierCurve curve;
ArrayList<LineSegment> controls;

int POLYLINE_POINTS_PER_CONTROL = 4;
float UAD_POINTS_PER_PIXEL = 0.05;

int numPolylinePoints;
PVector[] polylinePoints;
float polylineLength;
float[] polylineTimes;
float[] polylineLengths;
float[] polylineDistances;

int numUadPoints;
PVector[] uadPoints; // uniform arc-distance
PVector[] timeInterpolatedPoints;

PVector mousePressedPoint;

boolean showControls;

void setup() {
  size(800, 600);
  frameRate(10);

  curve = new BezierCurve();
  controls = new ArrayList<LineSegment>();

  showControls = false;

  LineSegment line;
  
  line = new LineSegment(111.0, 547.0, 86.0, 40.0);
  curve.addControl(line);
  controls.add(line);
  
  line = new LineSegment(367.0, 468.0, 356.0, 327.0);
  curve.addControl(line);
  controls.add(line);
  recalculate();
  
  line = new LineSegment(253.0, 159.0, 696.0, 433.0);
  curve.addControl(line);
  controls.add(line);
  recalculate();
}

void draw() {
  background(255);

  if (showControls) {
    noFill();
    stroke(128);

    curve.drawControls(this.g);
  }

  noFill();
  stroke(192);

  curve.draw(this.g);
  
  noFill();
  stroke(128);
  
  if (curve.numSegments() > 0) {
    PVector p0;
    for (int i = 0; i < numPolylinePoints; i++) {
      p0 = polylinePoints[i];
      ellipse(p0.x, p0.y, 5, 5);
    }
  }
  
  noFill();
  stroke(128);
  
  if (curve.numSegments() > 0) {
    PVector p0, p1;
    for (int i = 1; i < numPolylinePoints; i++) {
      p0 = polylinePoints[i-1];
      p1 = polylinePoints[i];
      line(p0.x, p0.y, p1.x, p1.y);
    }
  }
  
  fill(64);
  stroke(0);
  
  int numPoints = 10;
  for (int i = 0; i < numPoints; i++) {
    float t = (float) i / numPoints;
    PVector p = getPointOnPolylineApproximation(t);
    ellipse(p.x, p.y, 12, 12);
  }
}

void keyReleased() {
  switch (key) {
    case 'c':
      showControls = !showControls;
      break;

    case 'r':
      save("render.png");
      break;
  }
}

void mousePressed() {
  mousePressedPoint = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  LineSegment line = new LineSegment(mousePressedPoint.x, mousePressedPoint.y, mouseX, mouseY);
  curve.addControl(line);
  controls.add(line);
  recalculate();
  
  println(line.p0.x + ", " + line.p0.y + ", " + line.p1.x + ", " + line.p1.y);
}



private void recalculate() {
  if (controls.size() < 2) return;
  println("START recalculate");
  
  numPolylinePoints = controls.size() * POLYLINE_POINTS_PER_CONTROL;
  polylinePoints = new PVector[numPolylinePoints];
  int[] polylineControlIndices = new int[numPolylinePoints];
  polylineTimes = new float[numPolylinePoints];
  polylineLengths = new float[numPolylinePoints - 1];
  polylineDistances = new float[numPolylinePoints];
  polylineLength = 0;
  
  println("polyline points");
  println("index\tlength\tdistance");
  
  for (int i = 0; i < numPolylinePoints; i++) {
    polylineTimes[i] = (float)i / (numPolylinePoints - 1);
    polylinePoints[i] = getPointOnCurveNaive(polylineTimes[i]);
    polylineControlIndices[i] = getPointOnCurveNaiveIndex(polylineTimes[i]);
    
    if (i > 0) {
      PVector d = polylinePoints[i].get();
      d.sub(polylinePoints[i - 1]);
      polylineLengths[i - 1] = d.mag();
      polylineLength += d.mag();
      polylineDistances[i] = polylineLength;
      
      println(i + "\t" + d.mag() + "\t" + polylineLength);
    }
    else {
      polylineLengths[i] = 0;
      polylineDistances[i] = 0;
    }
  }
  
  numUadPoints = floor(polylineLength * UAD_POINTS_PER_PIXEL);
  uadPoints = new PVector[numUadPoints];
  timeInterpolatedPoints = new PVector[numUadPoints];
  float walkLength = polylineLength / (numUadPoints - 1);
  int polylinePointIndex = 0;
  
  println("numUadPoints=" + numUadPoints + ", walkLength=" + walkLength);
  
    println((polylinePointIndex)
      + "\t" + polylineLengths[polylinePointIndex]
      + "\t" + polylineDistances[polylinePointIndex]
      + "\tN/A"
      + "\t" + polylineTimes[polylinePointIndex]);
      
  for (int i = 0; i < numUadPoints; i++) {
    println("UAD Point: " + i);
    println((polylinePointIndex+1)
      + "\t" + polylineLengths[polylinePointIndex]
      + "\t" + polylineDistances[polylinePointIndex+1]
      + "\t" + (i * walkLength)
      + "\t" + polylineTimes[polylinePointIndex+1]);
    while (polylinePointIndex + 2 < numPolylinePoints
        && i * walkLength > polylineDistances[polylinePointIndex + 1]) {
      polylinePointIndex++;
      
      if (polylinePointIndex + 1 < numPolylinePoints) {
        println((polylinePointIndex+1)
          + "\t" + polylineLengths[polylinePointIndex]
          + "\t" + polylineDistances[polylinePointIndex+1]
          + "\t" + (i * walkLength)
          + "\t" + polylineTimes[polylinePointIndex+1]);
      }
    }
    
    if (polylinePointIndex >= numPolylinePoints) {
      uadPoints[i] = polylinePoints[numPolylinePoints - 1];
      println("Passed the end of the line.");
    }
    else {
      PVector d = polylinePoints[polylinePointIndex + 1].get();
      d.sub(polylinePoints[polylinePointIndex]);
      d.normalize();
      d.mult(i * walkLength - polylineDistances[polylinePointIndex]);
      d.add(polylinePoints[polylinePointIndex]);
      uadPoints[i] = d;
      
      float k = (i * walkLength - polylineDistances[polylinePointIndex]) / polylineLengths[polylinePointIndex];
      float t = polylineTimes[polylinePointIndex] + k * (polylineTimes[polylinePointIndex+1] - polylineTimes[polylinePointIndex]);
      println("k=" + k + ", t=" + t);
      
      timeInterpolatedPoints[i] = getPointOnCurveNaive(t);
    }
  }
  
  println("END recalculate");
}

/**
 * @see http://stackoverflow.com/a/4060392
 * @author michal@michalbencur.com
 */
private float bezierInterpolation(float a, float b, float c, float d, float t) {
  float t2 = t * t;
  float t3 = t2 * t;
  return a + (-a * 3 + t * (3 * a - a * t)) * t
  + (3 * b + t * (-6 * b + b * 3 * t)) * t
  + (c * 3 - c * 3 * t) * t2
  + d * t3;
}

private int getPointOnCurveNaiveIndex(float t) {
  int len = controls.size() - 1;
  int index = floor(t * len);
  return index;
}

private PVector getPointOnCurveNaive(float t) {
  if (controls.size() < 2) return null;
  if (t <= 0) return controls.get(0).p0.get();
  if (t >= 1.0) return controls.get(controls.size() - 1).p1.get();

  int len = controls.size() - 1;
  int index = floor(t * len);
  float u = (t * len - index);
  LineSegment line0 = controls.get(index);
  LineSegment line1 = controls.get(index + 1);
  if (index == 0) {
    return new PVector(
      bezierInterpolation(line0.p0.x, line0.p1.x, line1.p0.x, line1.p1.x, u),
      bezierInterpolation(line0.p0.y, line0.p1.y, line1.p0.y, line1.p1.y, u));
  }
  else {
    return new PVector(
      bezierInterpolation(line0.p1.x, 2 * line0.p1.x - line0.p0.x, line1.p0.x, line1.p1.x, u),
      bezierInterpolation(line0.p1.y, 2 * line0.p1.y - line0.p0.y, line1.p0.y, line1.p1.y, u));
  }
}

private PVector getPointOnPolylineApproximation(float t) {
  if (controls.size() <= 0) return null;
  if (t <= 0) return controls.get(0).p0.get();
  if (t >= 1) return controls.get(controls.size() - 1).p1.get();
  
  for (int i = 0; i < numPolylinePoints - 1; i++) {
    if (t * polylineLength < polylineDistances[i + 1]) {
      
      PVector p = polylinePoints[i + 1].get();
      p.sub(polylinePoints[i]);
      p.normalize();
      p.mult(t * polylineLength - polylineDistances[i]);
      p.add(polylinePoints[i]);
      
      return p;
    }
  }
  
  return null;
}

private PVector getPointOnCurve(float t) {
  if (controls.size() <= 0) return null;
  if (t <= 0) return controls.get(0).p0.get();
  if (t >= 1) return controls.get(controls.size() - 1).p1.get();
  
  for (int i = 0; i < numPolylinePoints - 1; i++) {
    if (t * polylineLength < polylineDistances[i + 1]) {
      float k = (t * polylineLength - polylineDistances[i]) / polylineLengths[i];
      float u = polylineTimes[i] + k * (polylineTimes[i + 1] - polylineTimes[i]);
      
      return getPointOnCurveNaive(u);
    }
  }
  
  return null;
}
