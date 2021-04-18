class VotingMotions {
  final String motion;

  VotingMotions(this.motion);

  VotingMotions.fromJson(Map<String, dynamic> json) : motion = json["motion"];
}
