import 'dart:math';

import 'package:openscad/metadata.dart';
import 'package:openscad/read_metadata.dart';

void main(List<String> arguments) {
  final metadata = arguments.fold(
    Metadata.empty(),
    (a, b) => a + readMetadata(b),
  );
  metadata.normalize();
  metadata.flipHorizontally();
  metadata.calibrate(
    metadata.lines[0][0],
    metadata.lines[0][1],
    metadata.lines[0][2],
    metadata.lines[0][3],
    150,
  );

  List<double> quadrilateralCentroid(List<num> q) {
    final xs = <double>[
      q[0].toDouble(),
      q[2].toDouble(),
      q[4].toDouble(),
      q[6].toDouble(),
    ];
    final ys = <double>[
      q[1].toDouble(),
      q[3].toDouble(),
      q[5].toDouble(),
      q[7].toDouble(),
    ];

    double areaTwice = 0;
    double cxTimes6A = 0;
    double cyTimes6A = 0;

    for (int i = 0; i < 4; i++) {
      final int j = (i + 1) & 3;
      final double cross = xs[i] * ys[j] - xs[j] * ys[i];
      areaTwice += cross;
      cxTimes6A += (xs[i] + xs[j]) * cross;
      cyTimes6A += (ys[i] + ys[j]) * cross;
    }

    final double area = areaTwice / 2.0;
    if (area == 0) {
      throw StateError('Degenerate polygon: area is zero.');
    }

    final double cx = cxTimes6A / (3.0 * areaTwice);
    final double cy = cyTimes6A / (3.0 * areaTwice);
    return [cx, cy];
  }

  print('difference() {');
  print('union() {');
  for (var q in metadata.quadrilaterals) {
    print('linear_extrude(height=2.2)');
    print('offset(r=2.5) {');
    print('offset(delta=-2.5) {');
    print(
      'polygon(points=[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]);',
    );
    print('}');
    print('}');
  }

  print("linear_extrude(height=0.8)");
  print("offset(r=2) {");
  print("union() {");
  for (var q in metadata.quadrilaterals) {
    print('offset(delta=1)');
    print(
      'polygon(points=[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]);',
    );
  }
  print("}");
  print("}");
  print("}");
  for (var q in metadata.quadrilaterals) {
    final c = quadrilateralCentroid(q);
    print('linear_extrude(height=2.2)');
    print('translate([${c[0]}, ${c[1]}, 0]) {');
    print('circle(r=4);');
    print('}');
  }
  print("}");
}
