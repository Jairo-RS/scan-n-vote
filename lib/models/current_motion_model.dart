import 'dart:convert';

import 'package:http/http.dart' as http;

//OLD MODEL CLASS (Will be removed)
//Model class for current motion. Includes all http and json functionalities
class CurrentMotion {
  final String motion;

  CurrentMotion({this.motion});

  factory CurrentMotion.fromJson(Map<String, dynamic> json) {
    return CurrentMotion(
      motion: json["current_motion"],
    );
  }
  static Future<List<CurrentMotion>> browseCurrentMotion() async {
    // Loading data from local JSON file
    // String currentMotionContent =
    //     await rootBundle.loadString('assets/json/current_voting_motion.json');

    // Get request from a remote server (Mock API) for current motion
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/a97a89a3-b927-4358-98c2-751ea500d1dc');

    // Url url = Uri.parse(
    //     'https://run.mocky.io/v3/869cbe73-434b-41b8-9815-3f6e3beef0f5');

    http.Response currentMotionResponse = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    // Verifying if http request was successfully completed
    if (currentMotionResponse.statusCode == 200) {
      String currentMotionContent = currentMotionResponse.body;
      // Parsing the string and returning a Json object
      List currentMotionCollection = json.decode(currentMotionContent);
      List<CurrentMotion> _currentmotion = currentMotionCollection
          .map((json) => CurrentMotion.fromJson(json))
          .toList();
      return _currentmotion;
    } else {
      // If not successful, display error code
      throw Exception(currentMotionResponse.statusCode);
    }
  }
}
