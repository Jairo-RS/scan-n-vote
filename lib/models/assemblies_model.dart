import 'dart:convert';

import 'package:http/http.dart' as http;

//Model class for assemblies. Includes all http and json functionalities
class Assemblies {
  final int pk;
  final String assemblyName;
  final int quorum;
  final String agenda;
  final bool archived;

  Assemblies(
      {this.pk, this.assemblyName, this.quorum, this.agenda, this.archived});

  factory Assemblies.fromJson(Map<String, dynamic> json) {
    return Assemblies(
      pk: json['pk'],
      assemblyName: json['assembly_name'],
      quorum: json['quorum'],
      agenda: json['agenda'],
      archived: json['archived'],
    );
  }

  //GET Request
  static Future<List<Assemblies>> fetchAssemblies() async {
    var url = Uri.parse(
        'https://scannvote.herokuapp.com/api/assemblies/?format=json');

    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    String content = utf8.decode(response.bodyBytes);
    // String content = response.body;
    List jsonReponse = json.decode(content);

    // Verifying if http request was successfully completed
    if (response.statusCode == 200) {
      return jsonReponse.map((job) => new Assemblies.fromJson(job)).toList();
    } else {
      // If not successful, display error code
      throw Exception(response.statusCode);
    }
  }
}
