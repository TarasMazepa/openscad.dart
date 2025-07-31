class SCAD {
  final String name;
  final String? value;
  final bool curlyBraces;
  final List<SCAD> children = List.empty(growable: true);
  final Map<String, dynamic> params;
  final bool semicolon;

  SCAD(
    this.name, {
    this.value,
    this.curlyBraces = false,
    this.params = const {},
    this.semicolon = false,
  });

  SCAD.difference() : this('difference', curlyBraces: true);

  SCAD.union() : this('union', curlyBraces: true);

  SCAD.circle(num r) : this('circle', params: {'r': r}, semicolon: true);

  SCAD.cylinder({required num h, required num r1, required num r2})
    : this('cylinder', params: {'h': h, 'r1': r1, 'r2': r2}, semicolon: true);

  SCAD.offset({num? r, num? delta})
    : this(
        'offset',
        params: {if (r != null) 'r': r, if (delta != null) 'delta': delta},
      );

  SCAD.translate(String value) : this('translate', value: value);

  SCAD.linearExtrude({required num height})
    : this('linear_extrude', params: {'height': height});

  SCAD.polygon(String points)
    : this('polygon', params: {'points': points}, semicolon: true);

  SCAD operator +(SCAD statement) {
    children.add(statement);
    return this;
  }

  SCAD withChild(SCAD child) {
    children.add(child);
    return this;
  }

  SCAD withChildren(Iterable<SCAD> children) {
    this.children.addAll(children);
    return this;
  }

  SCAD of(Iterable<SCAD> children) {
    return withChildren(children);
  }

  StringBuffer buildString({
    StringBuffer? buffer,
    String indent = "",
    bool newLine = false,
  }) {
    buffer ??= StringBuffer();
    if (newLine) buffer.write(indent);
    buffer.write(name);
    buffer.write('(');
    bool pastFirst = false;
    if (value != null) {
      pastFirst = true;
      buffer.write(value);
    }
    for (final param in params.entries) {
      if (pastFirst) {
        buffer.write(', ');
      }
      pastFirst = true;
      buffer.write(param.key);
      buffer.write('=');
      buffer.write(param.value);
    }
    buffer.write(')');
    if (curlyBraces && children.isNotEmpty) {
      buffer.write(' {');
      final childIndent = "  $indent";
      for (final child in children) {
        buffer.writeln();
        child.buildString(buffer: buffer, indent: childIndent, newLine: true);
      }
      buffer.writeln();
      buffer.write(indent);
      buffer.write('}');
    } else {
      final childIndent = "  $indent";
      for (final child in children) {
        buffer.write(' ');
        child.buildString(buffer: buffer, indent: childIndent, newLine: false);
      }
    }
    if (semicolon) buffer.write(';');
    return buffer;
  }

  @override
  String toString() {
    return buildString().toString();
  }
}
