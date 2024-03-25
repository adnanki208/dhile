import 'package:dhile/api/api_service.dart';
import 'package:dhile/controller/main_controller.dart';
import 'package:dhile/models/home.dart';
import 'package:dhile/models/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  Rx<bool> isLoading = true.obs;
  Rx<bool> isFail = false.obs;
  Rxn<BrandModel> brandModel = Rxn<BrandModel>();
  late ResponseModel response;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  MainController mainController = MainController();

  Future<void> getBrands() async {
    try {
      isLoading(true);
      response = await ApiService().fetchBrand();
      if (response.code != 1) {
        mainController.responseCheck(response, getBrands);
        isFail(true);
        isLoading(false);


      } else {
        brandModel(BrandModel.fromJson(response.data));
        isFail(false);
        isLoading(false);
      }
    } catch(e){
      print(e);
    }
  }


}
