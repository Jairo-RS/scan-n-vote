import 'dart:convert';

import 'package:http/http.dart' as http;

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

  //POST Request for user signup
  static Future<UserModel> createUser(
      String userName,
      String studentNumber,
      String password,
      String passwordConfirmation,
      String csrfmiddlewaretoken) async {
    final String signUpUrl = "https://scannvote.herokuapp.com/api/signup/";

    final response = await http.post(signUpUrl, body: {
      "username": userName,
      "student_id": studentNumber,
      "password1": password,
      "password2": passwordConfirmation,
      "csrfmiddlewaretoken": csrfmiddlewaretoken,
    });

    // Verifying if http request was successfully completed
    if (response.statusCode == 200) {
      final String responseString = response.body;
      return userModelFromJson(responseString);
    } else {
      // If not successful, display error status code (409)
      throw Exception(response.statusCode);
    }
  }
}
