import 'dart:convert';

import 'package:scan_n_vote/models/original_motion_model.dart';
import 'package:http/http.dart' as http;

//Class model for all motions
class Motions {
  final int pk;
  final String motion;
  final bool archived;
  final bool voteable;
  final int favor;
  final int agaisnt;
  final int abstained;
  final int assemblyID;
  final List<OriginalMotion> originalMotion;

  Motions(
      {this.pk,
      this.motion,
      this.archived,
      this.voteable,
      this.favor,
      this.agaisnt,
      this.abstained,
      this.assemblyID,
      this.originalMotion});

  factory Motions.fromJson(Map<String, dynamic> json) {
    //Creating List<OriginalMotion> and assinging to originalMotion
    var list = json['original_motion'] as List;
    print(list.runtimeType);

    //Iterating over list and mapping each object in list to OriginalMotion
    List<OriginalMotion> originalMotionList =
        list.map((i) => OriginalMotion.fromJson(i)).toList();

    //Map key to each value
    return Motions(
      pk: json['pk'],
      motion: json['motion_text'],
      archived: json['archived'],
      voteable: json['voteable'],
      favor: json['a_favor'],
      agaisnt: json['en_contra'],
      abstained: json['abstenido'],
      assemblyID: json['assembly_id'],
      originalMotion: originalMotionList,
    );
  }

  //GET Request function for all motions
  static Future<List<Motions>> fetchMotions() async {
    var url =
        Uri.parse('https://scannvote.herokuapp.com/api/motions/?format=json');

    http.Response response = await http.get(url);
    String content = utf8.decode(response.bodyBytes);
    List jsonReponse = json.decode(content);

    // Verifying if http request was successfully completed
    if (response.statusCode == 200) {
      return jsonReponse.map((job) => new Motions.fromJson(job)).toList();
    } else {
      // If not successful, display error code
      throw Exception(response.statusCode);
    }
  }
}
