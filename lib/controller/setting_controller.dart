
import 'package:dhile/api/api_service.dart';
import 'package:dhile/controller/main_controller.dart';
import 'package:dhile/models/faq.dart';
import 'package:dhile/models/home.dart';
import 'package:dhile/models/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  Rx<bool> isLoading = true.obs;
  Rx<bool> isFail = false.obs;

  Rxn<SocialModel> socialModel = Rxn<SocialModel>();
  Rxn<ContactModel> contactModel = Rxn<ContactModel>();
  late ResponseModel response;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  MainController mainController = MainController();

  Future<void> getSocial() async {
    try {
      isLoading(true);

      response = await ApiService().fetchSocial();
      if (response.code != 1) {
        mainController.responseCheck(response, getSocial);
        isFail(true);
        isLoading(false);
      } else {
        socialModel(SocialModel.fromJson(response.data));
        contactModel(ContactModel.fromJson(response.data));
        isFail(false);
        isLoading(false);
      }
    }catch(e){
      print(e);
    }
  }
}
