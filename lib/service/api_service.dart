// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:scan_n_vote/constants.dart';

// class APIService<T> {
//   final String url;
//   final dynamic body;
//   T Function(http.Response response) parse;

//   APIService({this.url, this.body, this.parse});
// }

// class APIWeb {
//   //get method
//   Future<T> getRequest<T>(APIService<T> resource) async {
//     final response = await http.get(Uri.parse(userUrl + resource.url));
//     if (response.statusCode == 200) {
//       return resource.parse(response);
//     } else {
//       throw Exception(response.statusCode);
//     }
//   }

//   //post method
//   Future<T> postRequest<T>(APIService<T> resource) async {
//     Map<String, String> header = {"Content-Type": "application/json"};

//     final response = await http.post(
//       Uri.parse(userUrl + resource.url),
//       body: jsonEncode(resource.body),
//       headers: header,
//     );
//     if (response.statusCode == 200) {
//       return resource.parse(response);
//     } else {
//       throw Exception(response.statusCode);
//     }
//   }
// }
