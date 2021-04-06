import 'dart:convert';

import 'package:http/http.dart' as http;

class AgendaEntry {
  final String entry;

  AgendaEntry({this.entry});

  factory AgendaEntry.fromJson(Map<String, dynamic> json) => AgendaEntry(
        entry: json['entry'],
      );

  static Future<List<AgendaEntry>> browse() async {
    // String content =
    //     await rootBundle.loadString('assets/json/agenda_entries.json');

    //Mock API to test http response
    var url = Uri.parse(
        'https://run.mocky.io/v3/6bcdf2f1-5a3d-4635-a8b6-f9ed46a6d2e6');
    http.Response response = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    String content = response.body;
    List collection = json.decode(content);
    List<AgendaEntry> _entries =
        collection.map((json) => AgendaEntry.fromJson(json)).toList();

    return _entries;
  }
}
