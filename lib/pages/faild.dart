import 'dart:async';
import 'package:dhile/controller/home_controller.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class FailPage extends StatefulWidget {
  const FailPage({super.key});

  @override
  State<FailPage> createState() => _FailPageState();
}

class _FailPageState extends State<FailPage> {

  HomeController homeController = HomeController();


  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 8), () {
      Get.offAllNamed('/home');
    });

  }

  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:   const AppBarCustom(showFilter: false),
      body: Column(

        children: <Widget>[
          //CENTER -- Blast
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35,),
              Text('BookingFailed'.tr,style: const TextStyle(fontSize: 30,color: Colors.black)),
              const SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/imgs/fail.svg',color: Colors.red),
                ],
              ),
              const SizedBox(height: 25,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ThankYouForTrying'.tr,textAlign: TextAlign.center,style: const TextStyle(fontSize: 30,color: Colors.black)),
                ],
              ),
              const SizedBox(height: 25,),
              const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('WeWillCallYouSoon',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.black)),
                ],
              ),
            ],
          ),





          //BOTTOM CENTER

        ],
      ),
    );
  }
}





