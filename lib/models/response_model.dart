class ResponseModel {
  final int responseCode;
  final String responseMessage;
  final dynamic responseData;

  ResponseModel({this.responseCode, this.responseMessage, this.responseData});

  //mapping json data
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json["response_data"] as List;
    final data = ResponseModel(
      responseCode: json["status_code"],
      responseMessage: json["response_message"],
      responseData: list,
    );
    return data;
  }
}
