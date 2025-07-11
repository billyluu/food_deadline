import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('resources/i18n/en.json'); // 改成你的 JSON 路徑
  final jsonStr = await file.readAsString();
  final Map<String, dynamic> jsonMap = json.decode(jsonStr);

  final buffer = StringBuffer();

  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln('import \'package:flutter/material.dart\';');
  buffer.writeln('import \'package:food_deadline/core/constants/app_localizations.dart\';');
  buffer.writeln('\n');
  buffer.writeln('enum AppString {');

  final entries = jsonMap.entries.toList();
  for (final entry in entries) {
    final enumName = _toCamelCase(entry.key);
    buffer.writeln('  $enumName(key: \'${entry.key}\'),');
  }

  buffer.writeln('  ;\n');
  buffer.writeln('  const AppString({ required this.key });');
  buffer.writeln('  final String key;\n');
  buffer.writeln('  String getL10n(BuildContext context, [List<String>? args]) {');
  buffer.writeln('    return AppLocalizations.of(context).translate(key, args);');
  buffer.writeln('  }');
  buffer.writeln('}');

  final output = File('lib/generated/app_string.s.dart');
  await output.writeAsString(buffer.toString());
  print('✅ AppString enum generated at lib/generated/app_string_enum.dart');
}

String _toCamelCase(String input) {
  final parts = input.split(RegExp(r'[_\-.]'));
  if (parts.isEmpty) return input;

  final first = parts.first;
  final rest = parts.skip(1).map((e) => e[0].toUpperCase() + e.substring(1));
  return first + rest.join();
}