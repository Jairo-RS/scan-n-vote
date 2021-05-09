// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  String csrfmiddlewaretoken;

  TokenModel({
    this.csrfmiddlewaretoken,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        csrfmiddlewaretoken: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": csrfmiddlewaretoken,
      };

  //GET Request
  static Future<TokenModel> getToken() async {
    // var tokenUrl = 'https://scannvote.herokuapp.com/api/token/?format=json';
    var tokenUrl =
        "https://run.mocky.io/v3/229880fe-920e-436d-a6db-4f8dce661764";

    http.Response response = await http.get(
      tokenUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    String content = response.body;
    // Verifying if http request was successfully completed
    if (response.statusCode == 200) {
      return TokenModel.fromJson(json.decode(content));
    } else {
      // If not successful, display error code
      throw Exception(response.statusCode);
    }
  }
}
