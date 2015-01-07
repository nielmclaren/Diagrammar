
PVector center;
ArrayList<PVector> points;
ArrayList<Float> radii;

FileNamer fileNamer;

void setup() {
  size(800, 600);

  fileNamer = new FileNamer("output/render", "png");

  center = new PVector(width/2, height/2);

  reset();
}

void reset() {
  float r;
  points = new ArrayList<PVector>();
  radii = new ArrayList<Float>();
  for (int i = 0; i < 0; i++) {
    points.add(new PVector(
      width/2 + (2*random(1)-1) * 200,
      height/2 + (2*random(1)-1) * 100));

    r = 70 + random(1) * 55;
    radii.add(r);
    radii.add(r * (1 + (2*random(1)-1) * 0.1));
  }
}



void draw() {
  PVector p;
  float rw, rh;

  background(255);

  fill(255);
  stroke(0);
  strokeWeight(3);
  for (int i = 0; i < points.size(); i++) {
    p = points.get(i);
    rw = radii.get(2*i);
    rh = radii.get(2*i+1);
    ellipse(p.x, p.y, rw, rh);
  }

  fill(255);
  noStroke();
  for (int i = 0; i < points.size(); i++) {
    p = points.get(i);
    rw = radii.get(2*i);
    rh = radii.get(2*i+1);
    ellipse(p.x, p.y, rw*0.8, rh*0.8);
  }

  /*
  fill(255);
  stroke(128);
  strokeWeight(1);
  for (int i = points.size() - 1; i >= 0; i--) {
    p = points.get(i);
    rw = radii.get(2*i);
    rh = radii.get(2*i+1);
    for (int j = 0; j < 10; j++) {
      ellipse(p.x, p.y, rw * (1 - (float)j/10), rh * (1 - (float)j/10));
    }
  }
  //*/
}

void mouseReleased() {
  points.add(new PVector(mouseX, mouseY));
  float r = 70 + random(1) * 20;
  radii.add(r);
  radii.add(r * (1 + (2*random(1)-1) * 0.2));
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

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
