import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

//User model login class
//This class contains the users necessary information to have login connection
//to the API.
class UserRepository {
  //API urls
  static String mainUrl = "https://scannvote.herokuapp.com";
  var loginUrl = '$mainUrl/api/login/';
  static String usernameHolder;

  //Used to store information about login functionality
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  //Verify if token exist in local storage
  Future<bool> hasToken() async {
    var value = await storage.read(key: 'set-cookie');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  //Used to write value of token to local storage
  Future<void> persistToken(String token) async {
    await storage.write(key: 'set-cookie', value: token);
  }

  //Delete token value from key in local storage
  Future<void> deleteToken() async {
    storage.delete(key: 'set-cookie');
    storage.deleteAll();
  }

  //Saves username value in local storage
  Future<void> saveUser(String user) async {
    await storage.write(key: 'user', value: user);
  }

  //Delete username value from key in local storage
  Future<void> deleteUsername() async {
    storage.delete(key: 'user');
    storage.deleteAll();
  }

  //POST method for login
  // ignore: missing_return
  Future<String> login(String username, String password) async {
    final response = await http.post(
      loginUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      //Obtains crsf token that is used to determine if user is logged in or
      //logged out
      String rawCookie = response.headers['set-cookie'];
      // String user = await storage.read(key: response.body);
      if (rawCookie != null) {
        int firstIndex = rawCookie.indexOf('=');
        int secondIndex = rawCookie.indexOf(';');
        return rawCookie.substring(firstIndex + 1, secondIndex);
      }
    } else {
      // If not successful, display error status code (409)
      throw Exception(response.statusCode);
    }
  }
}
