import 'dart:convert';

import 'package:http/http.dart' as http;

class PastAssemblies {
  final String date;
  final dynamic motions;
  final dynamic amendments;
  final dynamic results;
  final String quorum;

  PastAssemblies(
      {this.date, this.motions, this.amendments, this.results, this.quorum});

  factory PastAssemblies.fromJson(Map<String, dynamic> json) {
    return PastAssemblies(
      date: json['date'],
      motions: json['motions'],
      amendments: json['amendments'],
      results: json['results'],
      quorum: json['quorum'],
    );
  }

  static Future<List<PastAssemblies>> browsePastAssemblies() async {
    // Loads data from local Json file
    // String content =
    //     await rootBundle.loadString('assets/json/past_assemblies.json');

    // Mock API used to test http GET response
    var url = Uri.parse(
        'https://run.mocky.io/v3/eb685a2b-bd0a-43d5-a250-2eb5fbec0284');
    // var url = Uri.parse(
    //     'https://run.mocky.io/v3/492d7db8-802a-4b34-a69f-54a9115619f3');

    http.Response response = await http.get(url); // Http GET request

    await Future.delayed(Duration(seconds: 1));

    // Verifying if http request was successfully completed
    if (response.statusCode == 200) {
      String content = response.body;
      // Receiving strings and parsing it to Json objects
      List collection = json.decode(content);
      // Taking each map and translating to an instance of PastAssemblies class
      List<PastAssemblies> _pastAssemblies =
          collection.map((json) => PastAssemblies.fromJson(json)).toList();
      return _pastAssemblies;
    } else {
      // If not successful, display error code
      throw Exception(response.statusCode);
    }
  }
}
