import 'dart:convert';


CalculateModel calculateModelFromJson(String str) => CalculateModel.fromJson(json.decode(str));
String calculateToJson(Calculate data) => json.encode(data.toJson());

class CalculateModel {
  int discount;
  int total;
  int subTotal;
  int vat;

  CalculateModel({
    required this.discount,
    required this.total,
    required this.subTotal,
    required this.vat,
  });

  factory CalculateModel.fromJson(Map<String, dynamic> json) => CalculateModel(
    discount: json["discount"],
    total: json["total"],
    subTotal: json["sub-total"],
    vat: json["vat"],
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
