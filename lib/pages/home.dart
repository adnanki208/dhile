import 'package:dhile/constant.dart';
import 'package:dhile/controller/home_controller.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:dhile/widgets/bottom_nav.dart';
import 'package:dhile/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = HomeController();

  Future getData() async {
    await homeController.getHome();
    // print(homeController.data.cars[0].carType.name);
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBarCustom(homeController: homeController, showFilter: true),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Obx(() {
                if (homeController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Constant.mainColor,
                    ),
                  );
                } else {
                  if (homeController.isFail.value == false) {
                    if(homeController.cars.value!=null && homeController.cars.value?.cars.length!=0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            LimitedBox(
                                maxHeight: 80,
                                child: ListView.builder(
                                  itemCount:
                                  homeController.types.value!.carType.length,

                                  // itemCount: homeController.types.value!.body.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      homeController.firstTypeId(homeController
                                          .types.value!.carType[index].id);
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        homeController.changeType(homeController
                                            .types.value!.carType[index].id);
                                      },
                                      child: Animate(
                                        delay: 500.ms,
                                        effects: const [MoveEffect()],
                                        child: Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              side: BorderSide(
                                                  color: homeController
                                                      .typeId.value ==
                                                      0
                                                      ? homeController
                                                      .firstTypeId
                                                      .value ==
                                                      homeController
                                                          .types
                                                          .value!
                                                          .carType[index]
                                                          .id
                                                      ? Constant.mainColor!
                                                      : Constant.bgColor!
                                                      : homeController
                                                      .typeId.value ==
                                                      homeController
                                                          .types
                                                          .value!
                                                          .carType[index]
                                                          .id
                                                      ? Constant.mainColor!
                                                      : Constant.bgColor!)),
                                          color: Constant.bgColor,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                  const CircularProgressIndicator(
                                                      color: Colors.white),
                                                  imageUrl: Constant.domain +
                                                      homeController
                                                          .types
                                                          .value!
                                                          .carType[index]
                                                          .mediaMob!
                                                          .url,
                                                  fit: BoxFit.fitHeight),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                homeController.types.value!
                                                    .carType[index].title
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Constant.iconColor),
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: homeController.isLoading2.value == true
                                  ? Center(
                                child: CircularProgressIndicator(
                                  color: Constant.mainColor,
                                ),
                              )
                                  : RefreshIndicator(
                                  color: Constant.mainColor,
                                  onRefresh: homeController.filter,
                                  child:  CarCard(homeController: homeController,)),
                            )
                          ],
                        ),
                      );
                    }else{
                      return Center(
                        child: Text('No Cars Found!'.tr,style: TextStyle(fontSize: 20,color: Constant.dark)),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Connection Error'.tr,style: TextStyle(fontSize: 20,color: Constant.dark)),
                    );
                  }
                }
              }),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNav(
          index: 2,
        ));
  }
}
