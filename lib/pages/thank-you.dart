import 'dart:async';
import 'dart:math';
import 'package:dhile/constant.dart';
import 'package:dhile/controller/home_controller.dart';
import 'package:confetti/confetti.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class ThankPage extends StatefulWidget {
  const ThankPage({super.key});

  @override
  State<ThankPage> createState() => _ThankPageState();
}

class _ThankPageState extends State<ThankPage> {

  HomeController homeController = HomeController();
  late ConfettiController _controllerCenter;


  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    _controllerCenter.play();
    Timer(const Duration(seconds: 6), () {
      Get.offAllNamed('/home');
    });

  }

  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(showFilter: false),
      body: Container(
        color: Colors.white,
        child: Stack(

          children: <Widget>[
            //CENTER -- Blast
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height*0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Thank You  For Booking'.tr,textAlign: TextAlign.center,style: TextStyle(fontSize: 30,color: Constant.dark)),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top:  MediaQuery.of(context).size.height*0.4,
              right: MediaQuery.of(context).size.width*0.5,

              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                true, // start again as soon as the animation is finished
                colors:  [
                  Constant.dark!,
                  Constant.bgColor!,
                  Constant.mainColor!,
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top:  MediaQuery.of(context).size.height*0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/imgs/check.svg',color: Constant.mainColor),
                ],
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height*0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('We Will Call You Soon'.tr,textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Constant.dark)),
                    ],
                  ),
                ],
              ),
            ),



            //BOTTOM CENTER

          ],
        ),
      ),
    );
  }
}





