import 'package:dhile/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    // this.index;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
              onTap: () {
                Get.offAllNamed('/brand');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                SvgPicture.asset(index == 0 ?'assets/imgs/brand-a.svg':'assets/imgs/brand.svg',width:  Constant.iconSize,),

                  Text(
                    'Brands'.tr,
                    style: TextStyle(
                        color: index == 0
                            ? Constant.mainColor
                            : Constant.iconColor,
                        fontSize: Constant.fontSize),
                  )
                ],
              )),
          GestureDetector(
              onTap: () {
                Get.offAllNamed('/offers');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                SvgPicture.asset(index == 1 ?'assets/imgs/offers-a.svg':'assets/imgs/offers.svg',width:  Constant.iconSize,color:Colors.red,),

                  Text(
                    'Offers'.tr,
                    style: TextStyle(
                        color:  Colors.red,
                        fontSize: Constant.fontSize),
                  )
                ],
              )),
          GestureDetector(
              onTap: () {
                Get.offAllNamed('/home');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                SvgPicture.asset(index == 2 ?'assets/imgs/home-a.svg':'assets/imgs/home.svg',width:  Constant.iconSize,),

                  Text(
                    'Home'.tr,
                    style: TextStyle(
                        color: index == 2
                            ? Constant.mainColor
                            : Constant.iconColor,
                        fontSize: Constant.fontSize),
                  )
                ],
              )),
          GestureDetector(
              onTap: () {
                Get.offAllNamed('/faq');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(index == 3 ?'assets/imgs/faq-a.svg':'assets/imgs/faq.svg',width:  Constant.iconSize,),
                  Text(
                    "FAQ's".tr,
                    style: TextStyle(
                        color: index == 3
                            ? Constant.mainColor
                            : Constant.iconColor,
                        fontSize: Constant.fontSize),
                  )
                ],
              )),
          GestureDetector(
              onTap: () {
                Get.offAllNamed('/settings');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(index == 4 ?'assets/imgs/setting-a.svg':'assets/imgs/setting.svg',width:  Constant.iconSize,),
                  Text(
                    "Settings".tr,
                    style: TextStyle(
                        color: index == 4
                            ? Constant.mainColor
                            : Constant.iconColor,
                        fontSize: Constant.fontSize),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
