import 'dart:convert';
import 'dart:io';

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
  return Metadata(quadrilaterals, lines);
}
