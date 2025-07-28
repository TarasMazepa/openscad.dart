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

  @override
  String toString() {
    return {'quadrilaterals': quadrilaterals, 'lines': lines}.toString();
  }
}
