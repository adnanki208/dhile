import 'dart:convert';
import 'package:dhile/constant.dart';
import 'package:dhile/models/book.dart';
import 'package:dhile/models/calculater.dart';
import 'package:dhile/models/filter.dart';
import 'package:dhile/models/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService {
  static const FlutterSecureStorage storage = FlutterSecureStorage();
   var client = http.Client();


    var headers = {
    'accept-language': Get.locale.toString().substring(0,2)=='ar'?'ar':'en',
    'Content-Type': 'application/json'
  };

   Future<ResponseModel> fetchHome() async {
    try {
      String? sr = await storage.read(key: 'home');
      if (sr == null) {
        // print(headers);
        var res = await client
            .get(Uri.parse('${Constant.domain}api/home'),headers: headers);

        if (res.statusCode == 200) {
          var jsonString = res.body;
          await storage.write(key: "home", value: jsonString);
          return responseModelFromJson(jsonString);
        } else {
          return errorResponse(res.statusCode);
        }
      } else {
        return responseModelFromJson(sr);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> fetchArea() async {
    try {
      String? sr = await storage.read(key: 'area');
      if (sr == null) {
        // print(headers);
        var res = await client
            .get(Uri.parse('${Constant.domain}api/area'),headers: headers);

        if (res.statusCode == 200) {
          var jsonString = res.body;
          await storage.write(key: "area", value: jsonString);
          return responseModelFromJson(jsonString);
        } else {
          return errorResponse(res.statusCode);
        }
      } else {
        return responseModelFromJson(sr);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }

   Future<ResponseModel> fetchFaq() async {
    try {
      String? sr = await storage.read(key: 'faq');
      if (sr == null) {
        var res = await client
            .get(Uri.parse('${Constant.domain}api/faq',),headers: headers);

        if (res.statusCode == 200) {
          var jsonString = res.body;
          await storage.write(key: "faq", value: jsonString);

          return responseModelFromJson(jsonString);
        } else {
          return errorResponse(res.statusCode);
        }
      } else {
        return responseModelFromJson(sr);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> fetchSocial() async {
    try {
      String? sr = await storage.read(key: 'social');
      if (sr == null) {
        var res = await client
            .get(Uri.parse('${Constant.domain}api/contactAndSocial',),headers: headers);

        if (res.statusCode == 200) {
          var jsonString = res.body;
          await storage.write(key: "social", value: jsonString);

          return responseModelFromJson(jsonString);
        } else {
          return errorResponse(res.statusCode);
        }
      } else {
        return responseModelFromJson(sr);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> fetchBrand() async {
    try {
      String? sr = await storage.read(key: 'brand');
      if (sr == null) {
        var res = await client
            .get(Uri.parse('${Constant.domain}api/brands'),headers: headers);
        if (res.statusCode == 200) {
          var jsonString = res.body;

          await storage.write(key: "brand", value: jsonString);

          return responseModelFromJson(jsonString);
        } else {
          return errorResponse(res.statusCode);
        }
      } else {
        return responseModelFromJson(sr);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> fetchByOffers() async {
    try {
      String? sr = await storage.read(key: 'offers');
      if (sr == null) {
        var res = await client
            .get(Uri.parse('${Constant.domain}api/offers'),headers: headers);
        if (res.statusCode == 200) {
          var jsonString = res.body;

          await storage.write(key: "offers", value: jsonString);

          return responseModelFromJson(jsonString);
        } else {
          return errorResponse(res.statusCode);
        }
      } else {
        return responseModelFromJson(sr);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }

   Future<ResponseModel> fetchSearch(SearchModel searchModel) async {
    try {
      var res = await client.post(
          Uri.parse(
            '${Constant.domain}api/search',
          ),
          body: searchToJson(searchModel),
          headers: headers);

      if (res.statusCode == 200) {
        var jsonString = res.body;
        return responseModelFromJson(jsonString);
      } else {
        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> fetchByBrand(int id) async {
    try {
      var res = await client.post(
          Uri.parse(
            '${Constant.domain}api/carsBrand',
          ),
          body: jsonEncode(<String, String>{'id': id.toString()}),
          headers: headers);

      if (res.statusCode == 200) {
        var jsonString = res.body;
        return responseModelFromJson(jsonString);
      } else {
        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> getCarFeaturesById(String id) async {
    try {
      var res = await client.post(
          Uri.parse(
            '${Constant.domain}api/features',
          ),
          body: jsonEncode(<String, String>{'id': id}),
          headers: headers);

      if (res.statusCode == 200) {
        var jsonString = res.body;
        return responseModelFromJson(jsonString);
      } else {
        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> getCarById(String id) async {
    try {
      var res = await client.post(
          Uri.parse(
            '${Constant.domain}api/carDetails',
          ),
          body: jsonEncode(<String, String>{'id': id}),
          headers: headers);

      if (res.statusCode == 200) {
        var jsonString = res.body;
        return responseModelFromJson(jsonString);
      } else {
        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }


   Future<ResponseModel> bookSubmit(BookModel bookModel) async {
    try {
      var res = await client.post(
          Uri.parse(
            '${Constant.domain}api/book',
          ),
          body: bookToJson(bookModel),
          headers: headers);

      if (res.statusCode == 200) {
        var jsonString = res.body;
        return responseModelFromJson(jsonString);
      } else {
        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> calcSubmit(Calculate calculate) async {
    try {
      var res = await client.post(

          Uri.parse(
            '${Constant.domain}api/calculate',
          ),
          body: calculateToJson(calculate),
          headers: headers);
      if (res.statusCode == 200) {
        var jsonString = res.body;
        // print(calculateToJson(calculate));
        return responseModelFromJson(jsonString);
      } else {

        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }

   Future<ResponseModel> fetchFilter(FilterModel filterModel) async {
    try {

      var res = await client.post(
          Uri.parse(
            '${Constant.domain}api/filter',
          ),
          body: filterToJson(filterModel),
          headers: headers);
      if (res.statusCode == 200) {
        var jsonString = res.body;
        return responseModelFromJson(jsonString);
      } else {
        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }
   Future<ResponseModel> confirmPay(id) async {
    try {
      var res = await client.post(
          Uri.parse(
            '${Constant.domain}api/bookConfirm',
          ),
          body: jsonEncode(<String, String>{'id': id}),
          headers: headers);
      if (res.statusCode == 200) {
        var jsonString = res.body;
        return responseModelFromJson(jsonString);
      } else {
        return errorResponse(res.statusCode);
      }
    } catch (e) {
      return errorResponse(0);
    }
  }

   ResponseModel errorResponse(code) {
    ResponseModel responseModel = ResponseModel(
        code: -500, message: '${"ErrorInResponse".tr} ', data: null);
    return responseModel;
  }
}
