import 'dart:convert';
import 'package:http/http.dart' as http;

VotingModel votingModelFromJson(String str) =>
    VotingModel.fromJson(json.decode(str));

String votingModelToJson(VotingModel data) => json.encode(data.toJson());

class VotingModel {
  int choice;
  String csrftoken;

  VotingModel({this.choice, this.csrftoken});

  //mapping json data
  factory VotingModel.fromJson(Map<String, dynamic> json) => VotingModel(
        choice: json["choice"],
        csrftoken: json["csrfmiddlewaretoken"],
      );

  Map<String, dynamic> toJson() => {
        "choice": choice,
        "csrfmiddlewaretoken": csrftoken,
      };

  static Future<List<VotingModel>> browseCode() async {
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/e67c33eb-0b81-4d55-9138-b7d850e3ee96');
    http.Response codeResponse = await http.get(url);

    await Future.delayed(Duration(seconds: 2));

    // Verifying if http request was successfully completed
    if (codeResponse.statusCode == 200) {
      String codeContent = codeResponse.body;
      // Parsing the string and returning a Json object
      List codeCollection = json.decode(codeContent);
      List<VotingModel> _code =
          codeCollection.map((json) => VotingModel.fromJson(json)).toList();
      return _code;
    } else {
      // If not successful, display error code
      throw Exception(codeResponse.statusCode);
    }
  }
}
