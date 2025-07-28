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
  List<num> scaleQuadrilateral(List<num> quadrilateral, double scaleFactor) {
    double centerX =
        (quadrilateral[0] +
            quadrilateral[2] +
            quadrilateral[4] +
            quadrilateral[6]) /
        4;
    double centerY =
        (quadrilateral[1] +
            quadrilateral[3] +
            quadrilateral[5] +
            quadrilateral[7]) /
        4;
    List<double> result = List<double>.filled(8, 0);
    for (int i = 0; i < 4; i++) {
      int xIndex = i * 2;
      int yIndex = i * 2 + 1;
      result[xIndex] =
          (quadrilateral[xIndex] - centerX) * scaleFactor + centerX;
      result[yIndex] =
          (quadrilateral[yIndex] - centerY) * scaleFactor + centerY;
    }

    return result;
  }

  for (var quadrilateral in metadata.quadrilaterals) {
    print(
      'linear_extrude(height=2) polygon(points=[[${quadrilateral[0]},${quadrilateral[1]}],[${quadrilateral[2]},${quadrilateral[3]}],[${quadrilateral[4]},${quadrilateral[5]}],[${quadrilateral[6]},${quadrilateral[7]}]]);',
    );

    final scaledQuadrilateral = scaleQuadrilateral(quadrilateral, 2);
    print(
      'linear_extrude(height=1) polygon(points=[[${scaledQuadrilateral[0]},${scaledQuadrilateral[1]}],[${scaledQuadrilateral[2]},${scaledQuadrilateral[3]}],[${scaledQuadrilateral[4]},${scaledQuadrilateral[5]}],[${scaledQuadrilateral[6]},${scaledQuadrilateral[7]}]], center=true);',
    );
  }
}
