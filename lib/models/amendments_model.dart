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

  //POST Request
  Future<Amendments> fetchAmendments() async {
    //Need to finish implementation when url is available
    return null;
  }
}
