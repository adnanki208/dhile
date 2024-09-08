import 'dart:convert';

String searchToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
    String? key;

    SearchModel({
         this.key,
    });


    Map<String, dynamic> toJson() => {
        "key": key,
    };
}



String filterToJson(FilterModel data) => json.encode(data.toJson());

class FilterModel {
    String carType;
    String rentType;
    String? minPrice;
    String? maxPrice;
    List<int> brands;
    // String? carBody;

    FilterModel({
        required this.carType,
        required this.rentType,
         this.minPrice,
         this.maxPrice,
        required this.brands,
         // this.carBody,
    });



    Map<String, dynamic> toJson() => {
        "car_type": carType,
        "rent_type": rentType,
        "min_price": minPrice,
        "max_price": maxPrice,
        "brands": List<dynamic>.from(brands.map((x) => x)).toString(),
        // "car_body": carBody,
    };
}
