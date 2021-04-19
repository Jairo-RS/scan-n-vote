import 'dart:convert';

import 'package:http/http.dart' as http;

class PastMotions {
  final String pastMotion;
  dynamic allAmendments;
  final String result;

  PastMotions({
    this.pastMotion,
    this.allAmendments,
    this.result,
  });

  factory PastMotions.fromJson(Map<String, dynamic> json) {
    return PastMotions(
      pastMotion: json['past motion'],
      allAmendments: json['amendments'],
      result: json['result'],
    );
  }

  static Future<List<PastMotions>> browsePastMotions() async {
    // Loading data from local JSON file
    // String pastMotionsContent =
    //     await rootBundle.loadString('assets/json/past_motions.json');

    // Get request from a remote server (Mock API) for past motions
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/30ccd238-4174-4182-8596-4b57ccec5094');
    http.Response pastMotionsResponse = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    // Verifying if http request was successfully completed
    if (pastMotionsResponse.statusCode == 200) {
      String pastMotionsContent = pastMotionsResponse.body;
      // Parsing the strings and returning a Json objects
      List pastMotionsCollection = json.decode(pastMotionsContent);
      List<PastMotions> _pastmotions = pastMotionsCollection
          .map((json) => PastMotions.fromJson(json))
          .toList();

      return _pastmotions;
    } else {
      // If not successful, display error code
      throw Exception(pastMotionsResponse.statusCode);
    }
  }
}