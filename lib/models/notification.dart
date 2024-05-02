// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationFromJson(String str) => NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  String id;
  String image;
  String brand;

  NotificationModel({
    required this.id,
    required this.image,
    required this.brand,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    image: json["image"],
    brand: json["brand"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "brand": brand,
  };
}
