import 'package:dhile/api/api_service.dart';
import 'package:dhile/controller/main_controller.dart';
import 'package:dhile/models/features.dart';
import 'package:dhile/models/filter.dart';
import 'package:dhile/models/home.dart';
import 'package:dhile/models/response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeController extends GetxController {
  Rx<bool> isLoading = true.obs;
  Rx<bool> isLoading2 = false.obs;
  Rx<bool> isLoading3 = true.obs;
  Rx<bool> seeMore = false.obs;
  Rx<bool> isFail = false.obs;
  Rx<bool> isFail3 = false.obs;
  String? phone;
  String? whats;
  var brandsId = <int>[].obs;
  Rx<int>maxPriceDaily=1000.obs;
  Rx<int>maxPriceMonthly=0.obs;
  Rx<int>maxPrice=0.obs;
  Rx<int>minPrice=0.obs;
  Rx<String>rentType='daily'.obs;
  Rx<RangeValues> currentRangeValues =   const RangeValues(0, 1000).obs;
  Rx<int> bodyId = 0.obs;
  Rx<int> typeId = 0.obs;
  Rx<int> firstTypeId = 0.obs;
  late ContactModel contacts;
  RxString searchValue = ''.obs;
  FlutterSecureStorage storage = const FlutterSecureStorage();

  late ResponseModel response;
  // Rxn<BrandModel> bodies = Rxn<BrandModel>();
  Rxn<CarsModel> cars = Rxn<CarsModel>();
  Rxn<BrandModel> brands = Rxn<BrandModel>();
  Rxn<TypeModel> types = Rxn<TypeModel>();
  // Rxn<BodyModel> bodies = Rxn<BodyModel>();
  Rxn<FeaturesModel> features = Rxn<FeaturesModel>();
  MainController mainController = MainController();

  Future<void> getHome() async {
    try {
      isLoading(true);
      isLoading2(true);

      response = await ApiService().fetchHome();

      if (response.code != 1) {
        mainController.responseCheck(response, getHome);
        isFail(true);
      } else {
        isFail(false);
        maxPriceDaily(response.data['max-price-daily']);
        maxPriceMonthly(response.data['max-price-monthly']);
        maxPrice(response.data['max-price-daily']);
        currentRangeValues(RangeValues(0, maxPriceDaily.value.toDouble()));
        cars (CarsModel.fromJson(response.data));
        contacts = ContactModel.fromJson(response.data);
        // bodies(BodyModel.fromJson(response.data));
        brands(BrandModel.fromJson(response.data));
        types(TypeModel.fromJson(response.data));

        contacts.contact.forEach(
              (e) async{
            switch (e.type) {
              case 'mobile':{
                phone = e.url;
                await storage.write(key: "phone", value: phone);
              }
              case 'whatsapp':
                {
                  whats = e.url;
                  await storage.write(key: "whatsapp", value: whats);
                }
            }
          },
        );
      }

    } finally {
      isLoading(false);
      isLoading2(false);
    }
  }
  Future<void> changeBrand(id) async {
    try {
      // isLoading(true);
      if (brandsId.contains(id)) {
        brandsId.remove(id);
      } else {
        brandsId.add(id);
      }

    } catch (e) {
      print(e);
    }
  }
  void changeSeeMore() async {

    if(seeMore.value==false){
      seeMore(true);

    }else{
      seeMore(false);
    }


  }

  Future<void> filter() async {
    try {
      isLoading2(true);
      // isLoading3(true);
      late FilterModel filterModel = FilterModel(
          carType: typeId.value.toString(), brands: brandsId, rentType: rentType.value=="daily"?'1':'0',minPrice:currentRangeValues.value.start.toString(),maxPrice: currentRangeValues.value.end.toString());

      response = await ApiService().fetchFilter(filterModel);
      if (response.code != 1) {
        mainController.responseCheck(response, filter());
        isFail(true);
      } else {
        isFail(false);
        isLoading2(false);
        cars(CarsModel.fromJson(response.data));

        // bodies= BodiesModel.fromJson(response.data);
        // bodies.refresh();
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> fetchByBrand(int id) async {
    try {
      isLoading(true);
      response = await ApiService().fetchByBrand(id);
      if (response.code != 1) {
        mainController.responseCheck(response, fetchByBrand(id));
        isFail(true);
        isLoading(false);


      } else {
        cars(CarsModel.fromJson(response.data));
        whats= await storage.read(key: 'whatsapp');
        phone= await storage.read(key: 'phone');
        isFail(false);
        isLoading(false);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> getCarFeaturesById(String id) async {
    try {
        isLoading3(true);
      response = await ApiService().getCarFeaturesById(id);
      if (response.code == 1 || response.code == -2) {
        whats= await storage.read(key: 'whatsapp');
        phone= await storage.read(key: 'phone');
        features(FeaturesModel.fromJson(response.data));
        cars (CarsModel.fromJson(response.data));
        isFail3(false);
        isLoading3(false);
      } else {
        mainController.responseCheck(response, getCarFeaturesById(id));
        isFail3(true);
        isLoading3(false);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> getCarFeaturesById2(String id) async {
    try {
        isLoading3(true);
      response = await ApiService().getCarFeaturesById(id);
      if (response.code == 1 || response.code == -2) {
        whats= await storage.read(key: 'whatsapp');
        phone= await storage.read(key: 'phone');
        features(FeaturesModel.fromJson(response.data));
        isFail3(false);
        isLoading3(false);
      } else {
        mainController.responseCheck(response, getCarFeaturesById(id));
        isFail3(true);
        isLoading3(false);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> getCarById(String id) async {
    try {
        isLoading(true);
      response = await ApiService().getCarById(id);
      // print('aaa $id');
      if (response.code == 1) {
        cars (CarsModel.fromJson(response.data));
        isFail(false);
        isLoading(false);
      } else {
        mainController.responseCheck(response, getCarFeaturesById(id));
        isFail(true);
        isLoading(false);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> fetchByOffers() async {
    try {
      isLoading(true);
      response = await ApiService().fetchByOffers();
      if (response.code != 1) {
        mainController.responseCheck(response, fetchByOffers());
        isFail(true);
        isLoading(false);
      } else {
        isFail(false);
        isLoading(false);
        whats= await storage.read(key: 'whatsapp');
        phone= await storage.read(key: 'phone');
        cars(CarsModel.fromJson(response.data));

        // bodies= BodiesModel.fromJson(response.data);
        // bodies.refresh();
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> filterReset() async {
    try {
      isLoading2(true);
      bodyId(0);
      brandsId.clear();
      rentType('daily');
      currentRangeValues(RangeValues(0, maxPriceDaily.value.toDouble()));


      late FilterModel filterModel = FilterModel(
          carType: firstTypeId.value.toString(), brands: brandsId, rentType: '1',minPrice:currentRangeValues.value.start.toString(),maxPrice: currentRangeValues.value.end.toString());
      // print(filterModel.brands);
      response = await ApiService().fetchFilter(filterModel);
      // print(response.message);
      if (response.code != 1) {
        mainController.responseCheck(response, filter());
        isFail(true);
      } else {
        isFail(false);
        cars (CarsModel.fromJson(response.data));
        // bodies= BodiesModel.fromJson(response.data);
        // bodies.refresh();
      }
    } catch (e) {
      print(e);
    }finally{
      isLoading2(false);
    }
  }
  Future<void> postSearch(String search) async {
    try {
      isLoading2(true);
      late SearchModel searchModel = SearchModel();
      searchModel.key = search;

      response = await ApiService().fetchSearch(searchModel);
      if (response.code != 1) {
        mainController.responseCheck(response, postSearch(search));
        isFail(true);
      } else {
        isFail(false);
        cars (CarsModel.fromJson(response.data));
        // if(cars.value?.cars.length ==0){
        //   cars(null);
        //   print(cars.value?.cars[0]);
        // }
        // bodies= BodiesModel.fromJson(response.data);
      }
    } finally {
      isLoading2(false);
    }
  }

  Future<void> changeType(id) async {
    try {

      isLoading2(true);
      if(typeId.value!=id) {
        typeId(id);
        types.refresh();
      }

      late FilterModel filterModel = FilterModel(
          carType: typeId.value.toString(), brands: brandsId, rentType: rentType.value=="daily"?'1':'0',minPrice:currentRangeValues.value.start.toString(),maxPrice: currentRangeValues.value.end.toString());
      // print(filterModel.brands);
      response = await ApiService().fetchFilter(filterModel);
      // print(response.message);
      if (response.code != 1) {
        mainController.responseCheck(response, changeType(id));
        isFail(true);
      } else {
        isFail(false);
        cars (CarsModel.fromJson(response.data));
        // bodies= BodiesModel.fromJson(response.data);
        typeId.refresh();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }finally{
      isLoading2(false);
    }
  }
  Future<void> changeBody(id) async {
    try {

      if(bodyId.value!=id) {
        bodyId(id);

      }

        bodyId.refresh();
      }
     catch (e) {
      print(e);
    }
  }

}