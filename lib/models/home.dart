import 'dart:convert';

Home homeFromJson(String str) => Home.fromJson(json.decode(str));


class Home {
  int maxPriceDaily;
  int maxPriceMonthly;
  // List<Brand> carBody;
  List<Brand> carType;
  List<Car> cars;
  List<Brand> brands;
  List<Social> social;
  List<Contact> contact;

  Home({
    required this.maxPriceDaily,
    required this.maxPriceMonthly,
    // required this.carBody,
    required this.carType,
    required this.cars,
    required this.brands,
    required this.social,
    required this.contact,
  });

  factory Home.fromJson(Map<String, dynamic> json) => Home(
    maxPriceDaily: json["max-price-daily"],
    maxPriceMonthly: json["max-price-monthly"],
    // carBody: List<Brand>.from(json["car-body"].map((x) => Brand.fromJson(x))),
    carType: List<Brand>.from(json["car-type"].map((x) => Brand.fromJson(x))),
    cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
    social: List<Social>.from(json["social"].map((x) => Social.fromJson(x))),
    contact: List<Contact>.from(json["contact"].map((x) => Contact.fromJson(x))),
  );

}



class BrandModel {
  List<Brand> brands;

  BrandModel({
    required this.brands,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
  );
}
class TypeModel {
  List<Brand> carType;

  TypeModel({
    required this.carType,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
    carType: List<Brand>.from(json["car-type"].map((x) => Brand.fromJson(x))),
  );
}
// class BodyModel {
//   List<Brand> carBody;
//
//   BodyModel({
//     required this.carBody,
//   });
//
//   factory BodyModel.fromJson(Map<String, dynamic> json) => BodyModel(
//     carBody: List<Brand>.from(json["car-body"].map((x) => Brand.fromJson(x))),
//   );
// }

class Brand {
  int id;
  String title;
  int icon;
  Media? mediaIconApi;
  Media? mediaApi;
  Media? mediaMob;

  Brand({
    required this.id,
    required this.title,
    required this.icon,
    this.mediaIconApi,
    this.mediaApi,
    this.mediaMob,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    title: json["title"],
    icon: json["icon"],
    mediaIconApi: json["media_icon_api"] == null ? null : Media.fromJson(json["media_icon_api"]),
    mediaApi: json["media_api"] == null ? null : Media.fromJson(json["media_api"]),
    mediaMob: json["media_mob"] == null ? null : Media.fromJson(json["media_mob"]),
  );

}

class Media {
  int id;
  String url;

  Media({
    required this.id,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    url: json["url"],
  );


}


class CarsModel {
  List<Car> cars;

  CarsModel({
    required this.cars,
  });

  factory CarsModel.fromJson(Map<String, dynamic> json) => CarsModel(
    cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
  );
}

class Car {
  int id;
  int orderNumber;
  int typeId;
  int brandId;
  // int bodyId;
  int minDays;
  String model;
  String? offer;
  String description;
  String? note;
  int year;
  String innerColor;
  String outerColor;
  int seats;
  int transmission;
  int doors;
  int bags;
  int gas;
  String? engin;
  String imgs;
  num? oldDailyPrice;
  num? dailyPrice;
  num? oldMonthlyPrice;
  num? monthlyPrice;
  num? weaklyPrice;
  num? oldWeaklyPrice;
  num? deposit;
  String? dailyKm;
  String? weaklyKm;
  String? monthlyKm;
  String? kmPrice;
  Brand brandsApi;
  Brand typesApi;
  // Brand bodiesApi;

  Car({
    required this.id,
    required this.orderNumber,
    required this.typeId,
    required this.brandId,
    // required this.bodyId,
    required this.model,
    required this.minDays,
     this.offer,
    required this.description,
    required this.year,
    required this.innerColor,
    required this.outerColor,
    required this.seats,
    required this.doors,
    required this.gas,
    required this.transmission,
    required this.bags,
    required this.imgs,
     this.oldDailyPrice,
     this.dailyPrice,
     this.oldMonthlyPrice,
     this.monthlyPrice,
     this.weaklyPrice,
     this.oldWeaklyPrice,
     this.dailyKm,
     this.weaklyKm,
     this.monthlyKm,
     this.deposit,
     this.note,
     this.engin,
     this.kmPrice,
    required this.brandsApi,
    required this.typesApi,
    // required this.bodiesApi,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    id: json["id"],
    orderNumber: json["order_number"],
    typeId: json["type_id"],
    brandId: json["brand_id"],
    // bodyId: json["body_id"],
    minDays: json["min_days"],
    model: json["model"],
    offer: json["offer"],
    note: json["note"],
    description: json["description"],
    year: json["year"],
    innerColor: json["inner_color"],
    outerColor: json["outer_color"],
    seats: json["seats"],
    doors: json["doors"],
    gas: json["gas"],
    transmission: json["transmission"],
    bags: json["bags"],
    imgs: json["imgs"],
    oldDailyPrice: json["old_daily_price"],
    dailyPrice: json["daily_price"],
    oldMonthlyPrice: json["old_monthly_price"],
    monthlyPrice: json["monthly_price"],
    weaklyPrice: json["weakly_price"],
    oldWeaklyPrice: json["old_weakly_price"],
    dailyKm: json["daily_km"],
    weaklyKm: json["weakly_km"],
    monthlyKm: json["monthly_km"],
    deposit: json["deposit"],
    engin: json["engine"],
    kmPrice: json["km_price"],
    brandsApi: Brand.fromJson(json["brands_api"]),
    typesApi: Brand.fromJson(json["types_api"]),
    // bodiesApi: Brand.fromJson(json["bodies_api"]),
  );
}

class ContactModel {
  List<Contact> contact;

  ContactModel({
    required this.contact,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    contact: List<Contact>.from(json["contact"].map((x) => Contact.fromJson(x))),
  );
}

class SocialModel {
  List<Social> social;

  SocialModel({
    required this.social,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) => SocialModel(
    social: List<Social>.from(json["social"].map((x) => Social.fromJson(x))),
  );
}


class Contact {
  int id;
  String title;
  String icon;
  String type;
  String url;
  DateTime updatedAt;

  Contact({
    required this.id,
    required this.title,
    required this.icon,
    required this.type,
    required this.url,
    required this.updatedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"],
    title: json["title"],
    icon: json["icon"],
    type: json["type"],
    url: json["url"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

}
class Social {
  int id;
  String icon;
  String url;
  DateTime updatedAt;

  Social({
    required this.id,
    required this.icon,
    required this.url,
    required this.updatedAt,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
    id: json["id"],
    icon: json["icon"],
    url: json["url"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}
