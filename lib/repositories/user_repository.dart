import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Class contains connection to temporary API for testing
class UserRepository {
  //API urls
  static String mainUrl = "https://reqres.in";
  var loginUrl = '$mainUrl/api/login';

  //Used to store information about login functionality
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  //Advanced http packaged with additonal features
  final Dio _dio = Dio();

  //Verify if token exist in storage
  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  //Used to write value of token to storage
  Future<void> persistToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  //Delete token value from key
  Future<void> deleteToken() async {
    storage.delete(key: 'token');
    storage.deleteAll();
  }

  //POST method for login
  Future<String> login(String username, String password) async {
    Response response = await _dio.post(
      loginUrl,
      data: {
        "email": username,
        "password": password,
      },
    );
    return response.data["token"];
  }
}
