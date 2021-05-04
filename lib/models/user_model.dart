import 'dart:convert';

import 'package:http/http.dart' as http;

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

//User Signup model class used to map user json data
class UserModel {
  // final int id;
  final String userName;
  final String studentNumber;
  final String password;
  final String passwordConfirmation;

  UserModel({
    // this.id,
    this.userName,
    this.studentNumber,
    this.password,
    this.passwordConfirmation,
  });

  //mapping json data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // id: json["id"],
      userName: json["username"],
      studentNumber: json["student_id"],
      password: json["password1"],
      passwordConfirmation: json["password2"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": userName,
        "student_id": studentNumber,
        "password1": password,
        "password2": passwordConfirmation,
      };

  // //POST Request (write static and you can use from here)
  // Future<UserModel> createUser(String userName, String studentNumber,
  //     String password, String passwordConfirmation) async {
  //   //Need to finish implementation when url is available
  //   final String apiUrl = "https://reqres.in/api/users";

  //   final response = await http.post(apiUrl, body: {
  //     "username": userName,
  //     "student_id": studentNumber,
  //     "password1": password,
  //     "password2": passwordConfirmation,
  //   });

  //   if (response.statusCode == 200) {
  //     final String responseString = response.body;
  //     return userModelFromJson(responseString);
  //   } else {
  //     // If not successful, display error status code (409)
  //     throw Exception(response.statusCode);
  //   }
  // }
}
