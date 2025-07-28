import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:openscad/metadata.dart';
import 'package:path/path.dart' as p;

Metadata readMetadata(String filepath) {
  final metadata = jsonDecode(
    File.fromUri(p.toUri(filepath)).readAsStringSync(),
  )['metadata'];
  final quadrilaterals = <List<num>>[];
  final lines = <List<num>>[];
  for (final json in metadata.entries) {
    final points = json.value['xy'];
    if (points[0] == 7) {
      quadrilaterals.add(points.cast<num>().sublist(1));
    }
    if (points[0] == 5) {
      lines.add(points.cast<num>().sublist(1));
    }
  }
  if (quadrilaterals.isNotEmpty) {
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
      quadrilateral[0] = (quadrilateral[0] - minX).round();
      quadrilateral[2] = (quadrilateral[2] - minX).round();
      quadrilateral[4] = (quadrilateral[4] - minX).round();
      quadrilateral[6] = (quadrilateral[6] - minX).round();
      quadrilateral[1] = (quadrilateral[1] - minY).round();
      quadrilateral[3] = (quadrilateral[3] - minY).round();
      quadrilateral[5] = (quadrilateral[5] - minY).round();
      quadrilateral[7] = (quadrilateral[7] - minY).round();
    }
  }
  return Metadata(quadrilaterals, lines);
}
