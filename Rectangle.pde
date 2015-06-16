
class Rectangle {
  float x;
  float y;
  float w;
  float h;
  
  Rectangle(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  Rectangle union(Rectangle r) {
    Rectangle q = clone();
    q.x = min(x, r.x);
    q.y = min(y, r.y);
    q.w = max(x + w, r.x + r.w) - q.x;
    q.h = max(y + h, r.y + r.h) - q.y;
    return q;
  }
  
  Rectangle clone() {
    return new Rectangle(x, y, w, h);
  }
}
