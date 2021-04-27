import 'package:scan_n_vote/models/original_motion_model.dart';
import 'package:http/http.dart' as http;

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
  // final dynamic originalMotion;

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

  //GET Request
  Future<Motions> fetchMotions() async {
    //Need to finish implementation when url is available
    return null;
  }
}
