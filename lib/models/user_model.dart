import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scan_n_vote/models/token_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

//User Signup model class used to map user json data
class UserModel {
  final String userName;
  final String studentNumber;
  final String password;
  final String passwordConfirmation;
  final String csrfmiddlewaretoken;

  UserModel({
    this.userName,
    this.studentNumber,
    this.password,
    this.passwordConfirmation,
    this.csrfmiddlewaretoken,
  });

  //mapping json data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json["username"],
      studentNumber: json["student_id"],
      password: json["password1"],
      passwordConfirmation: json["password2"],
      csrfmiddlewaretoken: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": userName,
        "student_id": studentNumber,
        "password1": password,
        "password2": passwordConfirmation,
        "csrfmiddletoken": csrfmiddlewaretoken,
      };

  // //GET Request
  // static Future<String> getToken() async {
  //   //Initial token url
  //   http.Response response = await http.get(
  //     Uri.parse("https://scannvote.herokuapp.com/api/token/?format=json"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   // http.Response response = await http.get(tokenUrl);

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     // If not successful, display error status code (409)
  //     throw Exception(response.statusCode);
  //   }
  // }

  //POST Request (write static and you can use from here)
  static Future<UserModel> createUser(
      String userName,
      String studentNumber,
      String password,
      String passwordConfirmation,
      TokenModel csrfmiddlewaretoken) async {
    //Need to finish implementation when url is available
    final String signUpUrl = "https://scannvote.herokuapp.com/api/signup/";

    final response = await http.post(signUpUrl, body: {
      "username": userName,
      "student_id": studentNumber,
      "password1": password,
      "password2": passwordConfirmation,
      "csrfmiddlewaretoken": csrfmiddlewaretoken,
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      return userModelFromJson(responseString);
    } else {
      // If not successful, display error status code (409)
      throw Exception(response.statusCode);
    }
  }
}
