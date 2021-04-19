class PastMotions {
  final String pastMotion;
  dynamic allAmendments;
  final String result;

  PastMotions({
    this.pastMotion,
    this.allAmendments,
    this.result,
  });

  factory PastMotions.fromJson(Map<String, dynamic> json) {
    return PastMotions(
      pastMotion: json['past motion'],
      allAmendments: json['amendments'],
      result: json['result'],
    );
  }
}
