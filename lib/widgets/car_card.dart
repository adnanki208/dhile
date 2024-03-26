import 'package:dhile/constant.dart';
import 'package:dhile/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';


class CarCard extends StatelessWidget {
  final HomeController homeController;
  final bool? shrinkWrap;
  const CarCard({super.key,required this.homeController,this.shrinkWrap=false});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap:shrinkWrap==true? true:false,
      physics:shrinkWrap==true? const NeverScrollableScrollPhysics():const AlwaysScrollableScrollPhysics(),
      crossAxisCount: MediaQuery
          .of(context)
          .size
          .width <= 600 ? 1 : MediaQuery
          .of(context)
          .size
          .width <= 1200 ? 2 : 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      itemCount: homeController
          .cars.value!.cars.length,

      itemBuilder: (context, index) {
        List<String> image = homeController
            .cars.value!.cars[index].imgs
            .split(',');
        int oldDaily = 0;
        int oldMonthly = 0;

        if (homeController.cars.value!
            .cars[index].oldDailyPrice !=
            null) {
          oldDaily = (((homeController
              .cars
              .value!
              .cars[index]
              .oldDailyPrice! -
              homeController
                  .cars
                  .value!
                  .cars[index]
                  .dailyPrice) /
              homeController
                  .cars
                  .value!
                  .cars[index]
                  .oldDailyPrice!) *
              100)
              .ceil();
        }
        if (homeController
            .cars
            .value!
            .cars[index]
            .oldMonthlyPrice !=
            null &&
            homeController.cars.value!
                .cars[index].monthlyPrice !=
                null) {
          oldMonthly = (((homeController
              .cars
              .value!
              .cars[index]
              .oldMonthlyPrice! -
              homeController
                  .cars
                  .value!
                  .cars[index]
                  .monthlyPrice!) /
              homeController
                  .cars
                  .value!
                  .cars[index]
                  .oldMonthlyPrice!) *
              100)
              .ceil();
        }

        return Animate(
          delay: 500.ms,
          effects: const [ShimmerEffect()],
          child: GestureDetector(
            onTap: () {
              // print('aaaa');
              // Get.back();
              Get.toNamed('/carDetails',arguments: [homeController.cars.value!.cars[index]],preventDuplicates: false);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius
                    .circular(20),
              ),
              child: Card(
                color: Constant.bgCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10.0),
                ),

                elevation: 0,
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius
                              .all(
                              Radius.circular(
                                  10)),
                          child: Hero(
                            tag:
                            'car${homeController
                                .cars.value!
                                .cars[index].id}',
                            child: FlutterCarousel(
                              options: CarouselOptions(
                                enableInfiniteScroll: true,
                                // enlargeCenterPage: false,
                                disableCenter: true,
                                viewportFraction: 1.0,
                                aspectRatio: 1.5,
                                slideIndicator: CircularSlideIndicator(currentIndicatorColor: Constant.mainColor,indicatorBackgroundColor: Constant.mainColorOp,indicatorRadius: 4,itemSpacing: 12),

                              ),
                              items: image.map((e) {
                                return Builder(
                                    builder: (BuildContext context){
                                      return  FadeInImage
                                          .assetNetwork(
                                          placeholder:
                                          'assets/imgs/car-placeholder.png',
                                          image: Constant
                                              .domain +
                                              e,
                                          fit: BoxFit
                                              .cover);
                                    });
                              }).toList()

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets
                        .symmetric(vertical: 10.0,
                        horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      homeController
                                          .cars
                                          .value!
                                          .cars[index]
                                          .model
                                          .toUpperCase(),
                                      maxLines: 1,
                                      overflow: TextOverflow
                                          .ellipsis,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Constant
                                            .iconColor,
                                        fontWeight: FontWeight
                                            .bold,),
                                      textAlign: TextAlign
                                          .left,)
                                        .animate(
                                        delay: 500
                                            .ms)
                                        .slideX(),
                                  ),
                                  const SizedBox(
                                    width: 5,),
                                  Text(
                                    homeController
                                        .cars
                                        .value!
                                        .cars[index]
                                        .year
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Constant
                                            .iconColor),)
                                      .animate(
                                      delay: 500
                                          .ms)
                                      .slideX()
                                ],
                              ),
                            ),
                            SizedBox(width: 5,),
                            SizedBox(
                              width: 40,
                              child: Hero(
                                tag:
                                'brand${homeController
                                    .cars.value!
                                    .cars[index]
                                    .id}',
                                child: Image
                                    .network(
                                    Constant
                                        .domain +
                                        homeController
                                            .cars
                                            .value!
                                            .cars[
                                        index]
                                            .brandsApi
                                            .mediaIconApi!
                                            .url,
                                    fit: BoxFit
                                        .cover),
                              ),
                            ),
                          ],
                        ),

                        IntrinsicHeight(
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.max,
                            mainAxisAlignment:
                            homeController
                                .cars
                                .value!
                                .cars[
                            index]
                                .monthlyPrice ==
                                null
                                ? MainAxisAlignment
                                .center
                                : MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [

                                  oldDaily != 0
                                      ? Text(
                                    '${'before'
                                        .tr} ${homeController
                                        .cars
                                        .value!
                                        .cars[index]
                                        .oldDailyPrice}',
                                    style: TextStyle(
                                        decoration:
                                        TextDecoration
                                            .lineThrough,
                                        color: Constant
                                            .iconColor,
                                        decorationColor: Constant
                                            .iconColor),
                                  )
                                      : const SizedBox(
                                    height: 20,
                                  ),

                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .end,
                                        children: [
                                          Text(
                                              ' ${homeController
                                                  .cars
                                                  .value!
                                                  .cars[index]
                                                  .dailyPrice
                                                  .toString()}',
                                              style: TextStyle(
                                                  color: Constant
                                                      .mainColor,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize:
                                                  20)),
                                          Text(
                                              ' ${'AED'
                                                  .tr}',
                                              style: TextStyle(
                                                  color: Constant
                                                      .mainColor,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize:
                                                  20)),
                                          Text(
                                            'perDay'
                                                .tr,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),

                              homeController
                                  .cars
                                  .value!
                                  .cars[index]
                                  .monthlyPrice ==
                                  null
                                  ? Container()
                                  :
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [

                                  oldMonthly != 0
                                      ? Text(
                                    '${'before'
                                        .tr} ${homeController
                                        .cars
                                        .value!
                                        .cars[index]
                                        .oldMonthlyPrice}',
                                    style: TextStyle(
                                        decoration:
                                        TextDecoration
                                            .lineThrough,
                                        color: Constant
                                            .iconColor,
                                        decorationColor: Constant
                                            .iconColor),
                                  )
                                      : const SizedBox(
                                    height: 20,
                                  ),

                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .end,
                                        children: [
                                          Text(
                                              homeController
                                                  .cars
                                                  .value!
                                                  .cars[index]
                                                  .monthlyPrice
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Constant
                                                      .mainColor,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize:
                                                  20)),
                                          Text(
                                              ' ${'AED'
                                                  .tr}',
                                              style: TextStyle(
                                                  color: Constant
                                                      .mainColor,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize:
                                                  20)),
                                          Text(
                                            'perMont'
                                                .tr,
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
                        const SizedBox(height: 8,),
                        const Divider(thickness: 1,
                          color: Colors.grey,),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8),
                          decoration: BoxDecoration(
                            color: Constant
                                .bgColor,
                            borderRadius: BorderRadius
                                .circular(10),
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets
                                  .only(top: 10,
                                  bottom: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  Text(
                                    '${homeController
                                        .cars
                                        .value!
                                        .cars[index]
                                        .seats
                                        .toString()} ${'seats'
                                        .tr}',
                                    style: TextStyle(
                                        color: Constant
                                            .iconColor,
                                        fontSize: 15),),
                                  const VerticalDivider(
                                      color: Colors
                                          .grey,
                                      width: 2),
                                  homeController
                                      .cars.value!
                                      .cars[index]
                                      .transmission ==
                                      0
                                      ? Text(
                                    'manual'.tr,
                                    style: TextStyle(
                                        color: Constant
                                            .iconColor,
                                        fontSize: 15),)
                                      : Text(
                                    'auto'.tr,
                                    style: TextStyle(
                                        color: Constant
                                            .iconColor,
                                        fontSize: 15),),
                                  const VerticalDivider(
                                      color: Colors
                                          .grey,
                                      width: 2),
                                  Text(
                                    homeController
                                        .cars
                                        .value!
                                        .cars[index]
                                        .bodiesApi
                                        .title
                                        .toString(),
                                    style: TextStyle(
                                        color: Constant
                                            .iconColor,
                                        fontSize: 15),),
                                  const VerticalDivider(
                                      color: Colors
                                          .grey,
                                      width: 2),
                                  Text(
                                    homeController
                                        .cars
                                        .value!
                                        .cars[index]
                                        .typesApi
                                        .title
                                        .toString(),
                                    style: TextStyle(
                                        color: Constant
                                            .iconColor,
                                        fontSize: 15),),
                                ],),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround,
                          children: [


                            SizedBox(
                              height: 30,
                              child: TextButton(
                                  onPressed: () {
                                    launchUrlString(
                                        homeController
                                            .phone!);
                                  },
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty
                                          .all<
                                          EdgeInsets>(
                                          EdgeInsets
                                              .zero),
                                      backgroundColor:
                                      MaterialStateProperty
                                          .all(
                                          const Color(
                                              0xff2c7bbb)),
                                      shape: MaterialStateProperty
                                          .all<
                                          RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .all(
                                                Radius
                                                    .circular(
                                                    50)),
                                          ))),
                                  child: Animate(
                                    onPlay: (
                                        controller) =>
                                        controller
                                            .repeat(),
                                    effects: [
                                      ShakeEffect(
                                          delay:
                                          3000.ms)
                                    ],
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        Icon(
                                          Icons
                                              .phone_in_talk,
                                          color: Colors
                                              .white,
                                          size: 24,
                                        ),

                                      ],
                                    ),
                                  )),
                            ),

                            SizedBox(
                              height: 30,
                              child: TextButton(
                                  onPressed: () {
                                    launchUrlString(
                                        '${homeController
                                            .whats!} (${homeController
                                            .cars
                                            .value!
                                            .cars[index]
                                            .model})');
                                  },
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty
                                          .all<
                                          EdgeInsets>(
                                          EdgeInsets
                                              .zero),
                                      backgroundColor:
                                      MaterialStateProperty
                                          .all(
                                          const Color(
                                              0XFF25d366)),
                                      shape: MaterialStateProperty
                                          .all<
                                          RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .all(
                                                Radius
                                                    .circular(
                                                    50)
                                            ),
                                          ))),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons
                                            .whatsapp,
                                        color: Colors
                                            .white,
                                        size: 24,
                                      ),


                                    ],
                                  )),
                            ),

                            SizedBox(
                              height: 30,
                              child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(
                                        '/book',
                                        arguments: [
                                          homeController
                                              .cars
                                              .value!
                                              .cars[index]
                                        ]);
                                  },
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty
                                          .all<
                                          EdgeInsets>(
                                          const EdgeInsets
                                              .only(
                                              top: 0,
                                              right: 40,
                                              left: 40,
                                              bottom: 5)),
                                      backgroundColor:
                                      MaterialStateProperty
                                          .all(
                                          Constant
                                              .mainColor),
                                      shape: MaterialStateProperty
                                          .all<
                                          RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .all(
                                                Radius
                                                    .circular(
                                                    50)),
                                          ))),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [

                                      Text(
                                          'Book Now'
                                            .tr,
                                        style: const TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 15),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,)
                      ],
                    ),
                  ),


                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
