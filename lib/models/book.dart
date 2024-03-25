import 'dart:convert';




String bookToJson(BookModel data) => json.encode(data.toJson());

class BookModel {
    String? rentalType;
    int? carId;
    String? fromDate;
    String? toDate;
    String? name;
    String? email;
    String? phone;


    BookModel({
         this.rentalType,
         this.carId,
         this.fromDate,
         this.toDate,
         this.name,
         this.email,
         this.phone,
    });



    Map<String, dynamic> toJson() => {
        "rental_type": rentalType,
        "car_id": carId,
        "from_date": fromDate,
        "to_date": toDate,
        "name": name,
        "email": email,
        "phone": phone,

    };
}
