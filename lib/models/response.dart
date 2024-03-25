import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));


class ResponseModel {
  int code;
  String message;
  dynamic data;

  ResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    code: json["code"],
    message: json["message"],
    data: json["data"],
  );


}

