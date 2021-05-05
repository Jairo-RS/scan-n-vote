import 'dart:convert';
import 'package:http/http.dart' as http;

VotingRequirement votingRequirementFromJson(String str) =>
    VotingRequirement.fromJson(json.decode(str));

String votingRequirementToJson(VotingRequirement data) =>
    json.encode(data.toJson());

class VotingRequirement {
  String code;

  VotingRequirement({
    this.code,
  });

  //mapping json data
  factory VotingRequirement.fromJson(Map<String, dynamic> json) =>
      VotingRequirement(code: json["code"]);

  Map<String, dynamic> toJson() => {
        "code": code,
      };

  static Future<VotingRequirement> browseVotingRequirement() async {
    // Loading data from local JSON file
    // String currentMotionContent =
    //     await rootBundle.loadString('assets/json/current_voting_motion.json');

    // Get request from a remote server (Mock API) for current motion
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/7ee966fe-2b09-430c-b81f-00a42d08bdf9');
    http.Response votingResponse = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    // Verifying if http request was successfully completed
    if (votingResponse.statusCode == 200) {
      //String currentVotingContent = votingResponse.body;
      // Parsing the string and returning a Json object
      //   List currentVotingCollection = json.decode(currentVotingContent);
      //   List<VotingRequirement> _currentvote = currentVotingCollection
      //       .map((json) => VotingRequirement.fromJson(json))
      //       .toList();
      //   return _currentvote;
      // } else {
      //   // If not successful, display error code
      //   throw Exception(votingResponse.statusCode);
      // }
      return VotingRequirement.fromJson(json.decode(votingResponse.body));
    } else {
      throw Exception("Failed to load http");
    }
  }
}
