import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AgendaEntry {
  final String entry;

  AgendaEntry({this.entry});

  // Converts the unstructured JSON objects to values that can be used by
  // our code
  factory AgendaEntry.fromJson(Map<String, dynamic> json) => AgendaEntry(
        entry: json['entry'],
      );

  static Future<List<AgendaEntry>> browse() async {
    // Loads local json file (used to test)
    // String content =
    //     await rootBundle.loadString('assets/json/agenda_entries.json');

    // Mock API used to test http response
    var url = Uri.parse(
        'https://run.mocky.io/v3/6bcdf2f1-5a3d-4635-a8b6-f9ed46a6d2e6');

    // var url = Uri.parse(
    //     'https://run.mocky.io/v3/1123dd11-9c0d-4939-ba07-bc799fbb04d6');

    http.Response response = await http.get(url);

    await Future.delayed(Duration(seconds: 1));

    if (response.statusCode == 200) {
      String content = response.body;
      List collection = json.decode(content);
      List<AgendaEntry> _entries =
          collection.map((json) => AgendaEntry.fromJson(json)).toList();
      return _entries;
    } else {
      throw Exception(response.statusCode);
    }
  }
}
