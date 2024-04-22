import 'dart:convert';


Book bookFromJson(String str) => Book.fromJson(json.decode(str));


String bookToJson(BookModel data) => json.encode(data.toJson());



class Book {
  String url;

  Book({
    required this.url,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    url: json["url"],
  );
}

class BookModel {
    int? rentalType;
    int? carId;
    int? pick;
    int? drop;
    int? areaPick;
    int? areaDrop;
    String? fromDate;
    String? toDate;
    String? name;
    String? email;
    String? phone;
    String? countryCode;
    String? code;


    BookModel({
         this.rentalType,
         this.carId,
         this.pick,
         this.drop,
         this.areaPick,
         this.areaDrop,
         this.fromDate,
         this.toDate,
         this.name,
         this.email,
         this.phone,
         this.countryCode,
         this.code,
    });



    Map<String, dynamic> toJson() => {
        "rental_type": rentalType,
        "car_id": carId,
        "pick": pick,
        "drop": drop,
        "areaPick": areaPick,
        "areaDrop": areaDrop,
        "from_date": fromDate,
        "to_date": toDate,
        "name": name,
        "email": email,
        "phone": phone,
        "countryCode": countryCode,

    };
}
