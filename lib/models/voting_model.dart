import 'dart:convert';

VotingModel votingModelFromJson(String str) =>
    VotingModel.fromJson(json.decode(str));

String votingModelToJson(VotingModel data) => json.encode(data.toJson());

class VotingModel {
  String choice;

  VotingModel({
    this.choice,
  });

  //mapping json data
  factory VotingModel.fromJson(Map<String, dynamic> json) =>
      VotingModel(choice: json["choice"]);

  Map<String, dynamic> toJson() => {
        "choice": choice,
      };
}
