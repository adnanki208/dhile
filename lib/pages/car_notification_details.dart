import 'package:dhile/constant.dart';
import 'package:dhile/controller/home_controller.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:html/parser.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io' show Platform;

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CarNotificationDetailsPage extends StatefulWidget {
  final String id;

  const CarNotificationDetailsPage({super.key, required this.id});

  @override
  State<CarNotificationDetailsPage> createState() =>
      _CarNotificationDetailsPageState();
}

class _CarNotificationDetailsPageState
    extends State<CarNotificationDetailsPage> {
  HomeController homeController = HomeController();

  Future getData() async {
    await homeController.getCarById(widget.id);
    await homeController.getCarFeaturesById2(widget.id);
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    late final gas = ['Electric'.tr, 'Petrol'.tr, 'Diesel'.tr, 'Hybrid'.tr];
    late final transmission = ['manual'.tr, 'auto'.tr];
  // print(homeController.cars.value);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const AppBarCustom(showFilter: false,back: true,),
      body:
// Expanded(child: child)
        Column(
          children: [
            Expanded(child:   Obx(() {


              if (homeController.isLoading.value == true) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Constant.mainColor,
                  ),
                );
              } else {
                if (homeController.isFail.value == false) {
                  List<String> image = homeController.cars.value!.cars[0].imgs.split(',');
                  int oldDaily = 0;
                  int oldMonthly = 0;
                  var inner = HexColor(homeController.cars.value!.cars[0].innerColor);
                  var outer = HexColor(homeController.cars.value!.cars[0].outerColor);
                  if (homeController.cars.value!.cars[0].oldDailyPrice != null) {
                    oldDaily = (((homeController.cars.value!.cars[0].oldDailyPrice! -
                        homeController.cars.value!.cars[0].dailyPrice!) /
                        homeController.cars.value!.cars[0].oldDailyPrice!) *
                        100)
                        .ceil();
                  }
                  if (homeController.cars.value!.cars[0].oldMonthlyPrice != null &&
                      homeController.cars.value!.cars[0].monthlyPrice != null) {
                    oldMonthly = (((homeController.cars.value!.cars[0].oldMonthlyPrice! -
                        homeController.cars.value!.cars[0].monthlyPrice!) /
                        homeController.cars.value!.cars[0].oldMonthlyPrice!) *
                        100)
                        .ceil();
                  }


                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(height: 15,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              FlutterCarousel(
                                  options: CarouselOptions(
                                    enableInfiniteScroll: true,
                                    // enlargeCenterPage: false,
                                    disableCenter: true,
                                    viewportFraction: MediaQuery.of(context)
                                        .size
                                        .width <=
                                        600
                                        ? 1
                                        : MediaQuery.of(context).size.width <= 1200
                                        ? 0.5
                                        : 0.33,
                                    aspectRatio: MediaQuery.of(context)
                                        .size
                                        .width <=
                                        600
                                        ? 1.5
                                        : MediaQuery.of(context).size.width <= 1200
                                        ? 3
                                        : 4.5,
                                    slideIndicator: CircularSlideIndicator(
                                      slideIndicatorOptions: SlideIndicatorOptions(
                                        currentIndicatorColor: Constant.mainColor!,
                                        indicatorBackgroundColor:
                                        Constant.mainColorOp!,
                                        indicatorRadius: 4,
                                        itemSpacing: 12)),
                                  ),
                                  items: image.map((e) {
                                    return Builder(builder: (BuildContext context) {
                                      return FadeInImage.assetNetwork(
                                          placeholder:
                                          'assets/imgs/car-placeholder.png',
                                          image: Constant.domain + e,
                                          fit: BoxFit.cover);
                                    });
                                  }).toList()),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 15, left: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: SizedBox(
                                            width: 40,
                                            child: Image.network(
                                                Constant.domain +
                                                    homeController
                                                        .cars
                                                        .value!
                                                        .cars[0]
                                                        .brandsApi
                                                        .mediaIconApi!
                                                        .url,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Text(
                                            homeController.cars.value!.cars[0].model
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Constant.iconColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              right: 15, left: 15, bottom: 5),
                                          decoration: BoxDecoration(
                                              color: Constant.dark,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Text(
                                            homeController
                                                .cars.value!.cars[0].typesApi.title,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 14),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              right: 15, left: 15, bottom: 5),
                                          decoration: BoxDecoration(
                                              color: Constant.dark,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Text(
                                            homeController.cars.value!.cars[0].year
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Description'.tr,
                                          style: TextStyle(
                                              color: Constant.iconColor,
                                              fontSize: 22),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ReadMoreText(
                                      parse(homeController
                                          .cars.value!.cars[0].description)
                                          .body!
                                          .text,
                                      trimLines: 2,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Read More'.tr,
                                      trimExpandedText: 'Read less'.tr,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Car Colors'.tr,
                                          style: TextStyle(
                                              color: Constant.iconColor,
                                              fontSize: 22),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    color: outer,
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(20)),
                                                    border: Border.all(
                                                        color: Constant.bgColor!))),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text('Exterior Color'.tr),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: inner,
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(20)),
                                                  border: Border.all(
                                                      color: Constant.bgColor!)),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text('Interior Color'.tr),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Car Specs'.tr,
                                          style: TextStyle(
                                              color: Constant.iconColor,
                                              fontSize: 22),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 75,
                                      child: ListView(
                                        // This next line does the trick.
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          Animate(
                                            delay: 200.ms,
                                            effects: const [FadeEffect()],
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                side: BorderSide(
                                                    color: Constant.iconColor!,
                                                    width: 1.0),
                                              ),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: SvgPicture.asset(
                                                      'assets/imgs/i6.svg',
                                                      color: Constant.iconColor,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Text(transmission[homeController
                                                      .cars
                                                      .value!
                                                      .cars[0]
                                                      .transmission])
                                                ],
                                              ),
                                            ),
                                          ),
                                          Animate(
                                            delay: 200.ms,
                                            effects: const [FadeEffect()],
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                side: BorderSide(
                                                    color: Constant.iconColor!,
                                                    width: 1.0),
                                              ),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: SvgPicture.asset(
                                                      'assets/imgs/i7.svg',
                                                      color: Constant.iconColor,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Text(gas[homeController
                                                      .cars.value!.cars[0].gas])
                                                ],
                                              ),
                                            ),
                                          ),
                                          Animate(
                                            delay: 200.ms,
                                            effects: const [FadeEffect()],
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                side: BorderSide(
                                                    color: Constant.iconColor!,
                                                    width: 1.0),
                                              ),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: SvgPicture.asset(
                                                      'assets/imgs/i3.svg',
                                                      color: Constant.iconColor,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${homeController.cars.value!.cars[0].seats} ${'seats'.tr}')
                                                ],
                                              ),
                                            ),
                                          ),
                                          Animate(
                                            delay: 200.ms,
                                            effects: const [FadeEffect()],
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                side: BorderSide(
                                                    color: Constant.iconColor!,
                                                    width: 1.0),
                                              ),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: SvgPicture.asset(
                                                      'assets/imgs/i4.svg',
                                                      color: Constant.iconColor,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${homeController.cars.value!.cars[0].bags} ${'Bags'.tr}')
                                                ],
                                              ),
                                            ),
                                          ),
                                          Animate(
                                            delay: 200.ms,
                                            effects: const [FadeEffect()],
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                side: BorderSide(
                                                    color: Constant.iconColor!,
                                                    width: 1.0),
                                              ),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: SvgPicture.asset(
                                                      'assets/imgs/i2.svg',
                                                      color: Constant.iconColor,
                                                      width: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${homeController.cars.value!.cars[0].doors} ${'Doors'.tr}')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Rent Price'.tr,
                                          style: TextStyle(
                                              color: Constant.iconColor,
                                              fontSize: 22),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Constant.bgColor),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: homeController.cars
                                              .value!.cars[0].monthlyPrice ==
                                              null
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                oldDaily != 0
                                                    ? Text(
                                                  '${'before'.tr} ${homeController.cars.value!.cars[0].oldDailyPrice}',
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Constant.iconColor,
                                                      decorationColor:
                                                      Constant.iconColor),
                                                )
                                                    : const SizedBox(),
                                                Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                            homeController.cars.value!
                                                                .cars[0].dailyPrice
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Constant
                                                                    .mainColor,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: 20)),
                                                        Text('AED'.tr,
                                                            style: TextStyle(
                                                                color: Constant
                                                                    .mainColor,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: 20)),
                                                        Text(
                                                          'perDay'.tr,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            homeController.cars.value!.cars[0]
                                                .monthlyPrice ==
                                                null
                                                ? Container()
                                                : const VerticalDivider(
                                              color: Colors.grey,
                                              thickness: 1,
                                            ),
                                            homeController.cars.value!.cars[0]
                                                .monthlyPrice ==
                                                null
                                                ? Container()
                                                : Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                oldMonthly != 0
                                                    ? Text(
                                                  '${'before'.tr} ${homeController.cars.value!.cars[0].oldMonthlyPrice}',
                                                  style: TextStyle(
                                                      decoration:
                                                      TextDecoration
                                                          .lineThrough,
                                                      color: Constant
                                                          .iconColor,
                                                      decorationColor:
                                                      Constant
                                                          .iconColor),
                                                )
                                                    : const SizedBox(),
                                                Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .end,
                                                      children: [
                                                        Text(
                                                            homeController
                                                                .cars
                                                                .value!
                                                                .cars[0]
                                                                .monthlyPrice
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Constant
                                                                    .mainColor,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 20)),
                                                        Text('AED'.tr,
                                                            style: TextStyle(
                                                                color: Constant
                                                                    .mainColor,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 20)),
                                                        Text(
                                                          'perMont'.tr,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    if (homeController.cars.value!.cars[0].offer !=
                                        null)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(bottom: 5.0),
                                              child: Text(
                                                homeController
                                                    .cars.value!.cars[0].offer!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (homeController.cars.value!.cars[0].offer !=
                                        null)
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    Obx(() {
                                      if (homeController.isLoading3.value == true) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Constant.mainColor,
                                          ),
                                        );
                                      } else {
                                        if (homeController.isFail3.value == false) {
                                          if (homeController.features.value != null) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Car Features'.tr,
                                                      style: TextStyle(
                                                          color: Constant.iconColor,
                                                          fontSize: 22),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                MasonryGridView.count(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  crossAxisCount: MediaQuery.of(context)
                                                              .size
                                                              .width <=
                                                          600
                                                      ? 2
                                                      : MediaQuery.of(context).size.width <=
                                                              1200
                                                          ? 4
                                                          : 6,
                                                  mainAxisSpacing: 20,
                                                  crossAxisSpacing: 20,
                                                  itemCount: homeController.features.value!
                                                              .features.length >
                                                          6
                                                      ? homeController.seeMore.value ==
                                                              false
                                                          ? 6
                                                          : homeController.features.value!
                                                              .features.length
                                                      : homeController
                                                          .features.value!.features.length,
                                                  itemBuilder: (context, index) {
                                                    return Row(
                                                      children: [
                                                        SvgPicture.network(
                                                          Constant.domain +
                                                              homeController
                                                                  .features
                                                                  .value!
                                                                  .features[index]
                                                                  .media
                                                                  .url,
                                                          width: 20,
                                                          color: Constant.iconColorGray,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Flexible(
                                                            child: Text(
                                                          homeController.features.value!
                                                              .features[index].title,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Constant.iconColorGray),
                                                        ))
                                                      ],
                                                    );
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                homeController.features.value!.features
                                                            .length >
                                                        6
                                                    ? SizedBox(
                                                        width: MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                        child: OutlinedButton(
                                                            onPressed: () {
                                                              homeController
                                                                  .changeSeeMore();
                                                            },
                                                            style: OutlinedButton.styleFrom(
                                                              backgroundColor:
                                                                  Constant.bgGrayColor,
                                                              side: BorderSide.none,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        50.0),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      bottom: 5.0),
                                                              child: Text(
                                                                  homeController.seeMore
                                                                              .value ==
                                                                          true
                                                                      ? 'See Less'.tr
                                                                      : 'See More'.tr,
                                                                  style: TextStyle(
                                                                      color: Constant.dark,
                                                                      fontSize: 18)),
                                                            )),
                                                      )
                                                    : Container(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return Center(
                                            child: Text('Connection Error'.tr,
                                                style: TextStyle(
                                                    fontSize: 20, color: Constant.dark)),
                                          );
                                        }
                                      }
                                    }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 15.0,
                              left: 15,
                              top: 5,
                              bottom: Platform.isIOS ? 25 : 15.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(Constant.mainColor),
                                  elevation: const MaterialStatePropertyAll(0),
                                  shape: const MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))))),
                              onPressed: () {
                                Get.toNamed('/book',
                                    arguments: [homeController.cars.value!.cars[0]]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0, top: 10),
                                child: Text(
                                  'Book This Car'.tr,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              )),
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Text('Connection Error'.tr,
                        style: TextStyle(fontSize: 20, color: Constant.dark)),
                  );
                }
              }
            }),),
          ],
        )
    );
  }
}
