import 'package:dhile/constant.dart';
import 'package:dhile/controller/home_controller.dart';
import 'package:dhile/models/home.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:html/parser.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dhile/widgets/car_card.dart';
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

class CarDetailsPage extends StatefulWidget {
  final Car car;

  const CarDetailsPage({super.key, required this.car});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  HomeController homeController = HomeController();

  Future getData() async {
    await homeController.getCarFeaturesById(widget.car.id.toString());
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
    List<String> image = widget.car.imgs.split(',');
    int oldDaily = 0;
    int oldMonthly = 0;
    var inner = HexColor(widget.car.innerColor);
    var outer = HexColor(widget.car.outerColor);
    if (widget.car.oldDailyPrice != null) {
      oldDaily = (((widget.car.oldDailyPrice! - widget.car.dailyPrice!) /
                  widget.car.oldDailyPrice!) *
              100)
          .ceil();
    }
    if (widget.car.oldMonthlyPrice != null && widget.car.monthlyPrice != null) {
      oldMonthly = (((widget.car.oldMonthlyPrice! - widget.car.monthlyPrice!) /
                  widget.car.oldMonthlyPrice!) *
              100)
          .ceil();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const AppBarCustom(showFilter: false),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 15,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: 'car${widget.car.id}',
                    child: FlutterCarousel(
                        options: CarouselOptions(
                          enableInfiniteScroll: true,
                          // enlargeCenterPage: false,
                          disableCenter: true,
                          viewportFraction:
                              MediaQuery.of(context).size.width <= 600
                                  ? 1
                                  : MediaQuery.of(context).size.width <= 1200
                                      ? 0.5
                                      : 0.33,
                          aspectRatio: MediaQuery.of(context).size.width <= 600
                              ? 1.5
                              : MediaQuery.of(context).size.width <= 1200
                                  ? 3
                                  : 4.5,
                          slideIndicator: CircularSlideIndicator(
                            slideIndicatorOptions: SlideIndicatorOptions(
                              currentIndicatorColor: Constant.mainColor!,
                              indicatorBackgroundColor: Constant.mainColorOp!,
                              indicatorRadius: 4,
                              itemSpacing: 12),),
                        ),
                        items: image.map((e) {
                          return Builder(builder: (BuildContext context) {
                            return FadeInImage.assetNetwork(
                                placeholder: 'assets/imgs/car-placeholder.png',
                                image: Constant.domain + e,
                                fit: BoxFit.cover);
                          });
                        }).toList()),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 15, left: 15),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: SizedBox(
                                width: 40,
                                child: Hero(
                                  tag: 'brand${widget.car.id}',
                                  child: Image.network(
                                      Constant.domain +
                                          widget
                                              .car.brandsApi.mediaIconApi!.url,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                widget.car.model.toUpperCase(),
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
                                widget.car.typesApi.title,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if(widget.car.year!=null)
                            Container(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, bottom: 5),
                              decoration: BoxDecoration(
                                  color: Constant.dark,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50))),
                              child: Text(
                                widget.car.year.toString(),
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
                                  color: Constant.iconColor, fontSize: 22),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ReadMoreText(
                          parse(widget.car.description).body!.text,
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
                                  color: Constant.iconColor, fontSize: 22),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(20)),
                                      border:
                                          Border.all(color: Constant.bgColor!)),
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
                                  color: Constant.iconColor, fontSize: 22),
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
                              if(widget.car.kmPrice!=null)
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
                                        color: Constant.iconColor!, width: 1.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: SvgPicture.asset(
                                          'assets/imgs/i9.svg',
                                          color: Constant.iconColor,
                                          width: 30,
                                        ),
                                      ),
                                      Text(widget.car.kmPrice.toString())
                                    ],
                                  ),
                                ),
                              ),
                              if(widget.car.engin!=null)
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
                                          color: Constant.iconColor!, width: 1.0),
                                    ),
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: SvgPicture.asset(
                                            'assets/imgs/i10.svg',
                                            color: Constant.iconColor,
                                            width: 30,
                                          ),
                                        ),
                                        Text(widget.car.engin.toString())
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
                                        color: Constant.iconColor!, width: 1.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: SvgPicture.asset(
                                          'assets/imgs/i6.svg',
                                          color: Constant.iconColor,
                                          width: 30,
                                        ),
                                      ),
                                      Text(
                                          transmission[widget.car.transmission])
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
                                        color: Constant.iconColor!, width: 1.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: SvgPicture.asset(
                                          'assets/imgs/i7.svg',
                                          color: Constant.iconColor,
                                          width: 30,
                                        ),
                                      ),
                                      Text(gas[widget.car.gas])
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
                                        color: Constant.iconColor!, width: 1.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: SvgPicture.asset(
                                          'assets/imgs/i3.svg',
                                          color: Constant.iconColor,
                                          width: 30,
                                        ),
                                      ),
                                      Text('${widget.car.seats} ${'seats'.tr}')
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
                                        color: Constant.iconColor!, width: 1.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: SvgPicture.asset(
                                          'assets/imgs/i4.svg',
                                          color: Constant.iconColor,
                                          width: 30,
                                        ),
                                      ),
                                      Text('${widget.car.bags} ${'Bags'.tr}')
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
                                        color: Constant.iconColor!, width: 1.0),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: SvgPicture.asset(
                                          'assets/imgs/i2.svg',
                                          color: Constant.iconColor,
                                          width: 30,
                                        ),
                                      ),
                                      Text('${widget.car.doors} ${'Doors'.tr}')
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
                                  color: Constant.iconColor, fontSize: 22),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Constant.bgGrayColor),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.car.dailyPrice !=null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      oldDaily != 0
                                          ? Text(
                                        '${'AED'.tr} ${widget.car.oldDailyPrice}',
                                        style: const TextStyle(
                                            decoration:
                                            TextDecoration.lineThrough,
                                            color: Color(0xffFF4B4B),
                                            decorationColor:
                                            Color(0xffFF4B4B)),
                                      )
                                          : const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              '${widget.car.dailyPrice.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(' ${'AED'.tr}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text(
                                            'perDay'.tr,
                                            style: const TextStyle(
                                                color: Color(0Xff3B9D3B)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Icon(
                                              FontAwesomeIcons.road,
                                              color: Constant.mainColor,
                                              size: 14,
                                            ),
                                          ),
                                          Text(
                                              ' ${widget.car.dailyKm} ${'Km'.tr}',
                                              style: TextStyle(
                                                  color: Constant.mainColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ],
                                  ),
                                if (widget.car.weaklyPrice !=
                                    null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      widget.car.oldWeaklyPrice != 0
                                          ?  Text(
                                        '${'AED'.tr} ${widget.car.oldWeaklyPrice}',
                                        style: const TextStyle(
                                            decoration:
                                            TextDecoration.lineThrough,
                                            color: Color(0xffFF4B4B),
                                            decorationColor:
                                            Color(0xffFF4B4B)),
                                      )
                                          : const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                 widget.car.weaklyPrice
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18)),
                                              Text(' ${'AED'.tr}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16)),
                                              Text(
                                                'perWeek'.tr,
                                                style: const TextStyle(
                                                    color: Color(0Xff3B9D3B)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Icon(
                                                  FontAwesomeIcons.road,
                                                  color: Constant.mainColor,
                                                  size: 14,
                                                ),
                                              ),
                                              Text(
                                                  ' ${widget.car.weaklyPrice} ${'Km'.tr}',
                                                  style: TextStyle(
                                                      color: Constant.mainColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                if (widget.car.monthlyPrice !=
                                    null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      oldMonthly != 0
                                          ?  Text(
                                        '${'AED'.tr} ${widget.car.oldMonthlyPrice}',
                                        style: const TextStyle(
                                            decoration:
                                            TextDecoration.lineThrough,
                                            color: Color(0xffFF4B4B),
                                            decorationColor:
                                            Color(0xffFF4B4B)),
                                      )
                                          : const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                 widget.car.monthlyPrice
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18)),
                                              Text(' ${'AED'.tr}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16)),
                                              Text(
                                                'perMont'.tr,
                                                style: const TextStyle(
                                                    color: Color(0Xff3B9D3B)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Icon(
                                                  FontAwesomeIcons.road,
                                                  color: Constant.mainColor,
                                                  size: 14,
                                                ),
                                              ),
                                              Text(
                                                  ' ${widget.car.dailyKm} ${'Km'.tr}',
                                                  style: TextStyle(
                                                      color: Constant.mainColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16)),
                                            ],
                                          )
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
                        if (widget.car.offer != null)
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(widget.car.offer!,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.car.offer != null)
                          const SizedBox(
                            height: 15,
                          ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.check,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10,),
                                        Text('Insurance Included'.tr , style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),),

                                      ],
                                    ),
                                  ],),
                                  Column(children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.check,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10,),
                                        Text('${'Deposit'.tr} : ${widget.car.deposit} ${'AED'.tr}', style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        ) )

                                      ],
                                    ),
                                  ],),

                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.check,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10,),
                                  Text('${'Minimum Days For Rent'.tr} : ${widget.car.minDays}', style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                  ) ),

                                ],
                              ),
                            ],
                          ),
                        ),
                          const SizedBox(
                            height: 15,
                          ),






                        if (widget.car.note != null)
                        Row(
                          children: [
                            Text(
                              'Special Note'.tr,
                              style: TextStyle(
                                  color: Constant.iconColor, fontSize: 22),
                            ),
                          ],
                        ),
                        if (widget.car.note != null)
                          const SizedBox(
                            height: 15,
                          ),
                        if (widget.car.note != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration:  BoxDecoration(
                              color: Constant.bgGrayColor,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(widget.car.note!,style: const TextStyle(color: Colors.black,),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.car.note != null)
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
                                    if (homeController.cars.value != null)
                                      Row(
                                        children: [
                                          Text(
                                            'Similar Cars'.tr,
                                            style: TextStyle(
                                                color: Constant.iconColor,
                                                fontSize: 22),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (homeController.cars.value != null)
                                      CarCard(
                                        homeController: homeController,
                                        shrinkWrap: true,
                                      ),
                                    if (homeController.cars.value == null)
                                      Center(
                                        child: Text(
                                          'No Cars Found!'.tr,
                                          style: TextStyle(
                                              color: Constant.dark,
                                              fontSize: 20),
                                        ),
                                      )
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
              padding:
                   EdgeInsets.only(right: 15.0, left: 15,top: 5,bottom: Platform.isIOS ? 25:15.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Constant.mainColor),
                      elevation: const MaterialStatePropertyAll(0),
                      shape: const MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))))),
                  onPressed: () {
                    Get.toNamed('/book', arguments: [widget.car]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:  15.0, top: 10),
                    child: Text(
                      'Book This Car'.tr,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
