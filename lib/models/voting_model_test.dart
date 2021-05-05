// To parse this JSON data, do
//
//     final votingModelTest = votingModelTestFromJson(jsonString);

import 'dart:convert';

VotingModelTest votingModelTestFromJson(String str) =>
    VotingModelTest.fromJson(json.decode(str));

String votingModelTestToJson(VotingModelTest data) =>
    json.encode(data.toJson());

class VotingModelTest {
  VotingModelTest({
    this.name,
    this.job,
    this.id,
    this.createdAt,
  });

  String name;
  String job;
  String id;
  DateTime createdAt;

  factory VotingModelTest.fromJson(Map<String, dynamic> json) =>
      VotingModelTest(
        name: json["name"],
        job: json["job"],
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "job": job,
        "id": id,
        "createdAt": createdAt.toIso8601String(),
      };
}
