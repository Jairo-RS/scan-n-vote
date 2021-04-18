class VotingResults {
  final String aFavor;
  final String abstenido;
  final String enContra;

  VotingResults(this.aFavor, this.abstenido, this.enContra);

  VotingResults.fromJson(Map<String, dynamic> json)
      : aFavor = json["a favor"],
        abstenido = json["abstenidos"],
        enContra = json["en contra"];
}
