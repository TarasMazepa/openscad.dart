import 'dart:math';

class Metadata {
  final List<List<num>> quadrilaterals;
  final List<List<num>> lines;

  Metadata(this.quadrilaterals, this.lines);

  Metadata.empty() : this([], []);

  Metadata operator +(Metadata other) {
    return Metadata(quadrilaterals + other.quadrilaterals, lines + other.lines);
  }

  void calibrate(num x0, num y0, num x1, num y1, num calibrationMeasure) {
    final calibration =
        sqrt(pow(x0 - x1, 2) + pow(y0 - y1, 2)) / calibrationMeasure;
    for (final quadrilateral in quadrilaterals) {
      quadrilateral[0] = (quadrilateral[0] / calibration);
      quadrilateral[1] = (quadrilateral[1] / calibration);
      quadrilateral[2] = (quadrilateral[2] / calibration);
      quadrilateral[3] = (quadrilateral[3] / calibration);
      quadrilateral[4] = (quadrilateral[4] / calibration);
      quadrilateral[5] = (quadrilateral[5] / calibration);
      quadrilateral[6] = (quadrilateral[6] / calibration);
      quadrilateral[7] = (quadrilateral[7] / calibration);
    }
    for (final line in lines) {
      line[0] = (line[0] / calibration);
      line[1] = (line[1] / calibration);
      line[2] = (line[2] / calibration);
      line[3] = (line[3] / calibration);
    }
  }

  void flipHorizontally() {
    num maxX = quadrilaterals[0][0];
    for (final quadrilateral in quadrilaterals) {
      maxX = max(maxX, quadrilateral[0]);
      maxX = max(maxX, quadrilateral[2]);
      maxX = max(maxX, quadrilateral[4]);
      maxX = max(maxX, quadrilateral[6]);
    }
    for (final quadrilateral in quadrilaterals) {
      quadrilateral[0] = maxX - quadrilateral[0];
      quadrilateral[2] = maxX - quadrilateral[2];
      quadrilateral[4] = maxX - quadrilateral[4];
      quadrilateral[6] = maxX - quadrilateral[6];
    }
  }

  void normalize() {
    num minX = quadrilaterals[0][0];
    num minY = quadrilaterals[0][1];
    for (final quadrilateral in quadrilaterals) {
      minX = min(minX, quadrilateral[0]);
      minX = min(minX, quadrilateral[2]);
      minX = min(minX, quadrilateral[4]);
      minX = min(minX, quadrilateral[6]);
      minY = min(minY, quadrilateral[1]);
      minY = min(minY, quadrilateral[3]);
      minY = min(minY, quadrilateral[5]);
      minY = min(minY, quadrilateral[7]);
    }
    for (final quadrilateral in quadrilaterals) {
      quadrilateral[0] -= minX;
      quadrilateral[2] -= minX;
      quadrilateral[4] -= minX;
      quadrilateral[6] -= minX;
      quadrilateral[1] -= minY;
      quadrilateral[3] -= minY;
      quadrilateral[5] -= minY;
      quadrilateral[7] -= minY;
    }
  }

  @override
  String toString() {
    return {'quadrilaterals': quadrilaterals, 'lines': lines}.toString();
  }
}
