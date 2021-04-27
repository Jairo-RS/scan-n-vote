import 'package:http/http.dart' as http;

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
    final data = UserModel(
      // id: json["id"],
      userName: json["username"],
      studentNumber: json["student_id"],
      password: json["password1"],
      passwordConfirmation: json["password2"],
    );
    return data;
  }

  //POST Request
  Future<UserModel> createUser() async {
    //Need to finish implementation when url is available
    return null;
  }
}
