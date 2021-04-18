class QuorumCount {
  String currentQuorum;
  final String quorumNeeded;

  QuorumCount(this.currentQuorum, this.quorumNeeded);

  QuorumCount.fromJson(Map<String, dynamic> json)
      : currentQuorum = json["current quorum"],
        quorumNeeded = json["quorum needed"];
}
