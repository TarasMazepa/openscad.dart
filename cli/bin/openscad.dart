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

  print(
    SCAD
        .difference()
        .withChild(
          SCAD
              .union()
              .of(
                metadata.quadrilaterals.map(
                  (q) =>
                      SCAD.linearExtrude(height: 4) +
                      SCAD.offset(r: 2.5) +
                      SCAD.offset(delta: -2.5) +
                      SCAD.polygon(
                        '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                      ),
                ),
              )
              .withChild(
                SCAD.linearExtrude(height: 0.8) +
                    SCAD.offset(r: 2) +
                    SCAD.union().of(
                      metadata.quadrilaterals.map(
                        (q) =>
                            SCAD.offset(delta: 1) +
                            SCAD.polygon(
                              '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                            ),
                      ),
                    ),
              ),
        )
        .withChildren(
          metadata.quadrilaterals.map(
            (q) =>
                SCAD.translate("[0,0,0]") +
                SCAD.linearExtrude(height: 3) +
                SCAD.offset(r: 1.8) +
                SCAD.offset(delta: -2.5) +
                SCAD.polygon(
                  '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                ),
          ),
        )
        .withChildren(
          metadata.quadrilaterals.map(
            (q) =>
                SCAD.translate("[0,0,0]") +
                SCAD.linearExtrude(height: 5) +
                SCAD.offset(r: 1.1) +
                SCAD.offset(delta: -2.5) +
                SCAD.polygon(
                  '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                ),
          ),
        ),
  );
  print(
    SCAD
        .difference()
        .withChild(
          SCAD
              .union()
              .of(
                metadata.quadrilaterals.map(
                  (q) =>
                      SCAD.linearExtrude(height: 0.7) +
                      SCAD.offset(r: 1.35) +
                      SCAD.offset(delta: -2.5) +
                      SCAD.polygon(
                        '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                      ),
                ),
              )
              .of(
                metadata.quadrilaterals.map(
                  (q) =>
                      SCAD.linearExtrude(height: 4.3) +
                      SCAD.offset(r: 0.8) +
                      SCAD.offset(delta: -2.5) +
                      SCAD.polygon(
                        '[[${q[0]},${q[1]}],[${q[2]},${q[3]}],[${q[4]},${q[5]}],[${q[6]},${q[7]}]]',
                      ),
                ),
              ),
        )
        .of(
          metadata.quadrilaterals.map((q) {
            final c = quadrilateralCentroid(q);
            return SCAD.translate('[${c[0]}, ${c[1]}, 0]') +
                SCAD.cylinder(h: 3, r1: 3.5, r2: 0.5);
          }),
        ),
  );
}
