import 'dart:convert';
import 'package:http/http.dart' as http;

class Amendments {
  final int pk;
  final String motion;
  final bool archived;
  final bool voteable;
  final int favor;
  final int agaisnt;
  final int abstained;
  final int assemblyID;

  Amendments(
      {this.pk,
      this.motion,
      this.archived,
      this.voteable,
      this.favor,
      this.agaisnt,
      this.abstained,
      this.assemblyID});

  factory Amendments.fromJson(Map<String, dynamic> json) {
    return Amendments(
      pk: json['pk'],
      motion: json['motion_text'],
      archived: json['archived'],
      voteable: json['voteable'],
      favor: json['a_favor'],
      agaisnt: json['en_contra'],
      abstained: json['abstenido'],
      assemblyID: json['assembly_id'],
    );
  }

  //GET request
  Future<List<Amendments>> fetchAmendments() async {
    var url = Uri.parse(
        'https://scannvote.herokuapp.com/api/amendments/?format=json');

    http.Response response = await http.get(url);
    String content = utf8.decode(response.bodyBytes);
    List jsonReponse = json.decode(content);

    // Verifying if http request was successfully completed
    if (response.statusCode == 200) {
      return jsonReponse.map((job) => new Amendments.fromJson(job)).toList();
    } else {
      // If not successful, display error code
      throw Exception(response.statusCode);
    }
  }
}
