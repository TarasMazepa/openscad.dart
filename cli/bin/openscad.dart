import 'package:openscad/metadata.dart';
import 'package:openscad/read_metadata.dart';
import 'package:openscad/scad.dart';

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

  final thinHeight = 1.3;
  final caseHeight = thinHeight + 3.8;
  final totalHeight = thinHeight + caseHeight;
  final tubeSize = 2.8;

  final tubeToBases = [0.125, 0.15, 0.175, 0.2];
  final baseToHoles = [0.5, 0.6];
  num getTubeToBases(int index) {
    return tubeToBases[index % tubeToBases.length];
  }

  num getBaseToHoles(int index) {
    return baseToHoles[(index ~/ tubeToBases.length) % baseToHoles.length];
  }

  SCAD getHoleOffset(int index) {
    return SCAD.offset(
      r: tubeSize - getTubeToBases(index) - getBaseToHoles(index),
    );
  }

  // if (false)
  print(
    SCAD
        .difference()
        .withChild(
          SCAD.linearExtrude(height: totalHeight) +
              SCAD.offset(r: 5) +
              SCAD.offset(delta: -5) +
              SCAD.union().of(
                metadata.quadrilaterals.map(
                  (q) =>
                      SCAD.offset(delta: 2) +
                      SCAD.polygon(
                        '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                      ),
                ),
              ),
        )
        .withChildren(
          metadata.quadrilaterals.indexed.map(
            (q) =>
                SCAD.translate('[0,0,-1]') +
                SCAD.linearExtrude(height: totalHeight + 2) +
                getHoleOffset(q.$1) +
                SCAD.offset(delta: -2.5) +
                SCAD.polygon(
                  '[[${q.$2[0]},${q.$2[1]}],[${q.$2[2]},${q.$2[3]}],[${q.$2[4]},${q.$2[5]}],[${q.$2[6]},${q.$2[7]}]]',
                ),
          ),
        )
        .withChildren(
          metadata.quadrilaterals.map(
            (q) =>
                SCAD.translate('[0,0,-1]') +
                SCAD.linearExtrude(height: caseHeight + 1) +
                SCAD.offset(r: tubeSize) +
                SCAD.offset(delta: -2.5) +
                SCAD.polygon(
                  '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                ),
          ),
        ),
  );
}
