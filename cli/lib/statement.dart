class Statement {
  final String value;
  final bool curlyBraces;
  final List<Statement> children;
  final Map<String, dynamic> params;
  final bool semicolon;

  Statement(
    this.value, {
    this.curlyBraces = false,
    this.children = const [],
    this.params = const {},
    this.semicolon = false,
  });

  StringBuffer buildString({StringBuffer? buffer, String indent = ""}) {
    buffer ??= StringBuffer();
    buffer.write(indent);
    buffer.write(value);
    buffer.write('(');
    bool pastFirst = false;
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
        child.buildString(buffer: buffer, indent: childIndent);
      }
      buffer.writeln();
      buffer.write(indent);
      buffer.write('}');
    } else {
      final childIndent = "  $indent";
      for (final child in children) {
        buffer.write(' ');
        child.buildString(buffer: buffer, indent: childIndent);
      }
    }
    if (semicolon) buffer.write(';');
    return buffer;
  }
}
