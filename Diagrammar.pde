

PGraphics inputImg;

Brush brush;
int brushSize;
color brushColor;
int brushStep;
int prevStepX;
int prevStepY;

FileNamer fileNamer;
EmojiWorld world;

void setup() {
  size(1024, 768);
  smooth();

  fileNamer = new FileNamer("output/export", "png");
  world = new EmojiWorld(2 * width, 2 * height, 160);
}

void draw() {
  background(0);
  world.step();
  
  pushMatrix();
  translate(width/2 - world.player.pos.x, height/2 - world.player.pos.y);
  world.draw(this.g);
  popMatrix();
}

void keyPressed() {
  world.keyPressed();
}

void keyReleased() {
  world.keyReleased();
  
  switch (key) {
    case ' ':
      world.reset();
      break;
    case 'r':
      save(fileNamer.next());
      break;
    case 'p':
      world.isPaused = !world.isPaused;
      break;
    default:
  }
}

void mouseReleased() {
  println("drawBrush(" + mouseX + ", " + mouseY + ")");
  drawBrush(mouseX, mouseY);
  stepped(mouseX, mouseY);
  redraw();
}

void mouseDragged() {
  if (stepCheck(mouseX, mouseY)) {
    println("drawBrush(" + mouseX + ", " + mouseY + ")");
    drawBrush(mouseX, mouseY);
    stepped(mouseX, mouseY);
    redraw();
  }
}
void drawBrush(int x, int y) {
  //brush.squareBrush(x, y, brushSize, brushColor);
  //brush.squareFalloffBrush(x, y, brushSize, brushColor);
  //brush.circleBrush(x, y, brushSize, brushColor);
  brush.circleFalloffBrush(x, y, brushSize, brushColor);
  //brush.voronoiBrush(x, y, brushSize, brushColor);
}

boolean stepCheck(int x, int y) {
  float dx = x - prevStepX;
  float dy = y - prevStepY;
  return brushStep * brushStep < dx * dx  +  dy * dy;
}

void stepped(int x, int y) {
  prevStepX = x;
  prevStepY = y;
}

float randf(float low, float high) {
  return low + random(1) * (high - low);
}

int randi(int low, int high) {
  return low + floor(random(1) * (high - low));
}
