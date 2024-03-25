
import 'package:dhile/api/api_service.dart';
import 'package:dhile/controller/main_controller.dart';
import 'package:dhile/models/faq.dart';
import 'package:dhile/models/response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  Rx<bool> isLoading = true.obs;
  Rx<bool> isFail = false.obs;

  Rxn<FaqModel> faqModel = Rxn<FaqModel>();
  late ResponseModel response;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  MainController mainController = MainController();

  Future<void> getFaq() async {
    try {
      isLoading(true);
      response = await ApiService().fetchFaq();
      if (response.code != 1) {
        mainController.responseCheck(response, getFaq);
        isFail(true);
        isLoading(false);
      } else {
        faqModel(FaqModel.fromJson(response.data));
        isFail(false);
        isLoading(false);
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
