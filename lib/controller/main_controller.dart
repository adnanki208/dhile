import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController{






Future<void> responseCheck(response,fn) async {

  if (response.code == -500) {
if(fn != null) {
  await Future.delayed(const Duration(seconds: 3), () {
    fn();
  },);
}
    //


  } else {
    Get.showSnackbar(
      GetSnackBar(
        title: 'resoponseError'.tr,
        isDismissible: true,
        message: response.message,
        icon: const Icon(Icons.warning_amber, color: Colors.red),

        mainButton: fn == null ? null : TextButton(
          child: Text('ReTry'.tr,
              style: const TextStyle(color: Colors.lightBlueAccent)),
          onPressed: () async {
            await fn();
            Get.back();
          },

        ),


      ),
    );
  }
}
  void changeLang(var pram1,var pram2){
    var locale = Locale(pram1,pram2);
    Get.updateLocale(locale);
  }

}
