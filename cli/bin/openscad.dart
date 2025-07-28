import 'dart:math';

import 'package:openscad/metadata.dart';
import 'package:openscad/read_metadata.dart';

void main(List<String> arguments) {
  final metadata = arguments.fold(
    Metadata.empty(),
    (a, b) => a + readMetadata(b),
  );
  metadata.calibrate(
    metadata.lines[0][0],
    metadata.lines[0][1],
    metadata.lines[0][2],
    metadata.lines[0][3],
    150,
  );
  List<num> areaWeightedCentroid(List<num> c) {
    double a1 =
        ((c[2] - c[0]) * (c[5] - c[1]) - (c[4] - c[0]) * (c[3] - c[1])).abs() /
        2;
    double cx1 = (c[0] + c[2] + c[4]) / 3, cy1 = (c[1] + c[3] + c[5]) / 3;
    double a2 =
        ((c[4] - c[0]) * (c[7] - c[1]) - (c[6] - c[0]) * (c[5] - c[1])).abs() /
        2;
    double cx2 = (c[0] + c[4] + c[6]) / 3, cy2 = (c[1] + c[5] + c[7]) / 3;

    double totalArea = a1 + a2;
    if (totalArea == 0) {
      return [(c[0] + c[2] + c[4] + c[6]) / 4, (c[1] + c[3] + c[5] + c[7]) / 4];
    }
    double cx = (cx1 * a1 + cx2 * a2) / totalArea;
    double cy = (cy1 * a1 + cy2 * a2) / totalArea;
    return [cx, cy];
  }

  List<num> scaleQuadrilateral(List<num> quadrilateral, double scaleFactor) {
    final center = areaWeightedCentroid(quadrilateral);
    List<double> result = List<double>.filled(8, 0);
    for (int i = 0; i < 4; i++) {
      int xIndex = i * 2;
      int yIndex = i * 2 + 1;
      result[xIndex] =
          (quadrilateral[xIndex] - center[0]) * scaleFactor + center[0];
      result[yIndex] =
          (quadrilateral[yIndex] - center[1]) * scaleFactor + center[1];
    }

    return result;
  }

  List<num> outlineQuadrilateral(List<num> quadrilateral, double outlineWidth) {
    final center = areaWeightedCentroid(quadrilateral);

    List<double> result = List<double>.filled(8, 0);

    for (int i = 0; i < 4; i++) {
      int xIndex = i * 2;
      int yIndex = i * 2 + 1;

      num vx = quadrilateral[xIndex] - center[0];
      num vy = quadrilateral[yIndex] - center[1];
      double len = sqrt(vx * vx + vy * vy);

      double scale = len > 0 ? (len + outlineWidth) / len : 1.0;

      result[xIndex] = center[0] + vx * scale;
      result[yIndex] = center[1] + vy * scale;
    }

    return result;
  }

  for (var quadrilateral in metadata.quadrilaterals) {
    print(
      'linear_extrude(height=2) polygon(points=[[${quadrilateral[0]},${quadrilateral[1]}],[${quadrilateral[2]},${quadrilateral[3]}],[${quadrilateral[4]},${quadrilateral[5]}],[${quadrilateral[6]},${quadrilateral[7]}]]);',
    );

    final scaledQuadrilateral = outlineQuadrilateral(quadrilateral, 5);
    print(
      'linear_extrude(height=1) polygon(points=[[${scaledQuadrilateral[0]},${scaledQuadrilateral[1]}],[${scaledQuadrilateral[2]},${scaledQuadrilateral[3]}],[${scaledQuadrilateral[4]},${scaledQuadrilateral[5]}],[${scaledQuadrilateral[6]},${scaledQuadrilateral[7]}]]);',
    );
  }
}
