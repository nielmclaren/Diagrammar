
class VectorStepper {
  PVector pos, dir;
  float minPosDelta, maxPosDelta;
  float minAngleDelta, maxAngleDelta;

  VectorStepper() {
    PVector direction = new PVector(1, 0);
    direction.rotate((float)(random(1) * 2 * Math.PI));

    init(
      new PVector(0, 0), direction,
      1, 100,
      0, 2 * PI * 0.167);
  }

  VectorStepper(PVector position) {
    PVector direction = new PVector(1, 0);
    direction.rotate((float)(random(1) * 2 * Math.PI));

    init(
      position.get(), direction,
      1, 100,
      0, 2 * PI * 0.167);
  }

  VectorStepper(
      PVector position, PVector direction) {
    init(
      position, direction,
      1, 100,
      0, 2 * PI * 0.167);
  }

  VectorStepper(
      PVector position,
      float _minPosDelta, float _maxPosDelta,
      float _minAngleDelta, float _maxAngleDelta) {
    PVector direction = new PVector(1, 0);
    direction.rotate((float)(random(1) * 2 * Math.PI));

    init(
      position, direction,
      _minPosDelta, _maxPosDelta,
      _minAngleDelta, _maxAngleDelta);
  }

  VectorStepper(
      PVector position, PVector direction,
      float _minPosDelta, float _maxPosDelta,
      float _minAngleDelta, float _maxAngleDelta) {
    init(
      position, direction,
      _minPosDelta, _maxPosDelta,
      _minAngleDelta, _maxAngleDelta);
  }

  VectorStepper(
      PVector position,
      float _minPosDelta, float _maxPosDelta) {
    PVector direction = new PVector(1, 0);
    direction.rotate((float)(random(1) * 2 * Math.PI));

    init(
      position, direction,
      _minPosDelta, _maxPosDelta,
      0, 2 * PI * 0.167);
  }

  VectorStepper(
      PVector position, PVector direction,
      float _minPosDelta, float _maxPosDelta) {
    init(
      position, direction,
      _minPosDelta, _maxPosDelta,
      0, 2 * PI * 0.167);
  }

  PVector curr() {
    return pos.get();
  }

  PVector next() {
    int sign = 1 - 2 * floor(random(2));
    dir.normalize();
    dir.rotate((float)sign * map(random(1), 0, 1, minAngleDelta, maxAngleDelta));
    dir.mult(map(random(1), 0, 1, minPosDelta, maxPosDelta));
    pos.add(dir);
    return pos.get();
  }

  PVector getPosition() {
    return pos;
  }

  PVector getDirection() {
    return dir;
  }

  private void init(
      PVector _pos, PVector _direction,
      float _minPosDelta, float _maxPosDelta,
      float _minAngleDelta, float _maxAngleDelta) {
    pos = _pos;
    dir = _direction;

    minPosDelta = _minPosDelta;
    maxPosDelta = _maxPosDelta;
    minAngleDelta = _minAngleDelta;
    maxAngleDelta = _maxAngleDelta;
  }
}
