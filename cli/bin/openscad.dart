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

  print('difference() { union() {');
  for (var q in metadata.quadrilaterals) {
    print('''
linear_extrude(height=1.6) offset(r=2.5) { offset(delta=-2.5) {
  polygon(points=[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]);
} };
''');
  }

  print("linear_extrude(height=0.8) offset(r=2) { union() {");
  for (var q in metadata.quadrilaterals) {
    print(
      'offset(delta=1) polygon(points=[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]);',
    );
  }
  print("} }");
  print("}");
  for (var q in metadata.quadrilaterals) {
    print('''
linear_extrude(height=1.6) offset(r=1) { offset(delta=-2.5) {
  polygon(points=[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]);
} };
''');
  }
  print("}");
}
