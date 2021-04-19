//User model class used to map user json data
class UserModel {
  final int id;
  final String userName;
  final String studentNumber;
  final String password;
  final String passwordConfirmation;

  UserModel({
    this.id,
    this.userName,
    this.studentNumber,
    this.password,
    this.passwordConfirmation,
  });

  //mapping json data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = UserModel(
      id: json["id"],
      userName: json["username"],
      studentNumber: json["student_id"],
      password: json["password"],
      passwordConfirmation: json["password2"],
    );
    return data;
  }
}
