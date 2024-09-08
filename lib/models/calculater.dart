import 'dart:convert';


CalculateModel calculateModelFromJson(String str) => CalculateModel.fromJson(json.decode(str));
String calculateToJson(Calculate data) => json.encode(data.toJson());

class CalculateModel {
  num discount;
  num total;
  num subTotal;
  num vat;
  num rent;
  num pick;
  num drop;

  CalculateModel({
    required this.discount,
    required this.total,
    required this.subTotal,
    required this.vat,
    required this.drop,
    required this.pick,
    required this.rent,
  });

  factory CalculateModel.fromJson(Map<String, dynamic> json) => CalculateModel(
    discount: json["discount"],
    total: json["total"],
    subTotal: json["sub-total"],
    vat: json["vat"],
    drop: json["drop"],
    pick: json["pick"],
    rent: json["rent"],
  );
}
class Calculate {
  int? carId;
  String? fromDate;
  String? toDate;
  int? pick;
  int? areaPick;
  int? drop;
  int? areaDrop;
  String? code;

  Calculate({
     this.carId,
     this.fromDate,
     this.toDate,
     this.pick,
     this.areaPick,
     this.drop,
     this.areaDrop,
     this.code,
  });


  Map<String, dynamic> toJson() => {
    "car_id": carId,
    "from_date": fromDate,
    "to_date": toDate,
    "pick": pick,
    "areaPick": areaPick,
    "drop": drop,
    "areaDrop": areaDrop,
    "code": code,
  };
}
