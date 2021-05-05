//OriginalMotion will contain the information of a motion's amendments
class OriginalMotion {
  final int pk;
  final String motion;
  final bool archived;
  final bool voteable;
  final int favor;
  final int agaisnt;
  final int abstained;
  final int assemblyID;

  OriginalMotion(
      {this.pk,
      this.motion,
      this.archived,
      this.voteable,
      this.favor,
      this.agaisnt,
      this.abstained,
      this.assemblyID});

  factory OriginalMotion.fromJson(Map<String, dynamic> json) {
    return OriginalMotion(
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
}
