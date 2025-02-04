import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;



void main() {
  final key = '1LzvER05e7Sf2NAnXWuv7FMMAyEn3HJlhjQsN46jcZ0M';
  final gid = '0';
  final link = 'https://docs.google.com/spreadsheets/d/$key/export?format=csv&id=$key&gid=$gid';

  final response = http.get(Uri.parse(link));

  response.then((value) {
    final body = utf8.decode(value.bodyBytes);
    final rowsAsListOfValues = const CsvToListConverter().convert(body);

    print(rowsAsListOfValues);

  });
}
