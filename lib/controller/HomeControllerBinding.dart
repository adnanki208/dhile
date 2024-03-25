import 'package:dhile/controller/home_controller.dart';
import 'package:get/get.dart';


class HomeControllerBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}