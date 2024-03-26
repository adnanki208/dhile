import 'package:dhile/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppBarCustom extends StatelessWidget  implements PreferredSizeWidget{
  const AppBarCustom({
    super.key,
     this.homeController,
    required this.showFilter,
  });

  final    homeController;
  final bool showFilter;
  void openBottomSheet() {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Filter'.tr,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Constant.iconColor),
              ),
            ),
            Obx(() {
              return Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                homeController.rentType('daily');
                                homeController.currentRangeValues(RangeValues(
                                    0,
                                    homeController.maxPriceDaily.value
                                        .toDouble()));
                              },
                              child: Container(

                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color:
                                    homeController.rentType.value == 'daily'
                                        ? Constant.mainColor
                                        : Constant.bgColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month_outlined,size: 20,color:  homeController.rentType.value == 'daily'
                                        ? Colors.black
                                        : Colors.grey),
                                    const SizedBox(width: 5,),
                                    Text('daily'.tr,
                                        style: TextStyle(
                                          color: homeController.rentType.value == 'daily'
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 16
                                        ),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            )),
                        const SizedBox(width: 8,),
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                homeController.rentType('monthly');
                                homeController.currentRangeValues(RangeValues(
                                    0,
                                    homeController.maxPriceMonthly.value
                                        .toDouble()));
                              },
                              child: Container(

                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color:
                                    homeController.rentType.value == 'monthly'
                                        ? Constant.mainColor
                                        : Constant.bgColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month_outlined,size: 20,color:  homeController.rentType.value == 'monthly'
                                        ? Colors.black
                                        : Colors.grey),
                                    const SizedBox(width: 5,),
                                    Text('monthly'.tr,
                                        style: TextStyle(
                                            color: homeController.rentType.value == 'monthly'
                                                ? Colors.black
                                                : Colors.grey,
                                            fontSize: 16
                                        ),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),


                    const SizedBox(height: 20),
                    Text(
                      'Type Of Vehicle'.tr,
                      style: TextStyle(
                          fontSize: 20,

                          color: Constant.iconColor),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 60,
                        child: GridView.count(
                          childAspectRatio: 0.6,
                          crossAxisCount: 1,
                          // itemCount: homeController.bodies.value!.body.length,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            homeController.bodies.value!.carBody.length+1,
                                (index) {
                              if(index==0){
                                return GestureDetector(
                                  onTap: () {
                                    homeController.changeBody(0);
                                  },
                                  child: Animate(
                                    delay: 200.ms,
                                    effects: const [FadeEffect()],
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        side: homeController.bodyId == 0
                                            ? BorderSide(
                                            color: Constant.mainColor!,
                                            width: 1.0)
                                            : BorderSide(
                                            color: Constant.iconColor!,
                                            width: 1.0),
                                      ),
                                      color:Colors.white,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('All'.tr,style: const TextStyle(fontSize: 16),textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }else {
                                index=index-1;
                                return GestureDetector(
                                  onTap: () {
                                    homeController.changeBody(homeController
                                        .bodies.value!.carBody[index].id);
                                  },
                                  child: Animate(
                                    delay: 200.ms,
                                    effects: const [FadeEffect()],
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        side: homeController.bodyId ==
                                            homeController.bodies.value!
                                                .carBody[index].id
                                            ? BorderSide(
                                            color: Constant.mainColor!,
                                            width: 1.0)
                                            : BorderSide(
                                            color: Constant.iconColor!,
                                            width: 1.0),
                                      ),
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Text(homeController
                                              .bodies
                                              .value!
                                              .carBody[index].title,
                                              style: const TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        )),


                    const SizedBox(height: 20),
                    Text(
                      'Brands'.tr,
                      style: TextStyle(
                          fontSize: 20,

                          color: Constant.iconColor),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 100,
                        child: GridView.count(
                          childAspectRatio: 0.7,
                          crossAxisCount: 1,
                          // itemCount: homeController.bodies.value!.body.length,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            homeController.brands.value!.brands.length,
                                (index) {
                              return GestureDetector(
                                onTap: () {
                                  homeController.changeBrand(homeController
                                      .brands.value!.brands[index].id);
                                },
                                child: Animate(
                                  delay: 200.ms,
                                  effects: const [FadeEffect()],
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      side: homeController.brandsId.contains(
                                          homeController.brands.value!
                                              .brands[index].id)
                                          ? BorderSide(
                                          color: Constant.mainColor!,
                                          width: 1.0)
                                          : BorderSide(
                                          color: Constant.iconColor!,
                                          width: 1.0),
                                    ),
                                    color:Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(

                                          width: 40,
                                          child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                                  color: Colors.white),
                                              imageUrl: Constant.domain +
                                                  homeController
                                                      .brands
                                                      .value!
                                                      .brands[index]
                                                      .mediaIconApi!
                                                      .url,
                                              fit: BoxFit.fill),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Text(homeController
                                              .brands
                                              .value!
                                              .brands[index].title),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                    const SizedBox(height: 22),
                    Text(
                      'Price Range'.tr,
                      style: TextStyle(
                          fontSize: 20,

                          color: Constant.iconColor),
                    ),
                    const SizedBox(height: 10),
                    RangeSlider(


                      activeColor: Constant.mainColor,
                      values: homeController.currentRangeValues.value,
                      max: homeController.rentType.value == 'daily'
                          ? homeController.maxPriceDaily.value.toDouble()
                          : homeController.maxPriceMonthly.value.toDouble(),
                      divisions: 100,
                      labels: RangeLabels(
                        homeController.currentRangeValues.value.start
                            .round()
                            .toString(),
                        homeController.currentRangeValues.value.end
                            .round()
                            .toString(),
                      ),
                      onChanged: (RangeValues values) {
                        homeController.maxPrice(values.end.toInt());
                        homeController.minPrice(values.start.toInt());
                        homeController.currentRangeValues.value = values;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${homeController.currentRangeValues.value.start.toInt()}',
                              style: TextStyle(color: Constant.dark,fontSize: 16)),
                          Text(
                              '${homeController.currentRangeValues.value.end.toInt()}',
                              style: TextStyle(color: Constant.dark,fontSize: 16)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      homeController.filterReset();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text('Reset'.tr,style: TextStyle(color: Constant.dark,fontSize: 20)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      homeController.filter();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Constant.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                        side: BorderSide(color: Constant.mainColor!)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child:  Text('Filter'.tr,style: const TextStyle(color: Colors.black,fontSize: 20)),
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(

      scrolledUnderElevation: 0,
      toolbarHeight: 100,
      backgroundColor: Colors.white,
      elevation: 0,

      shape: Border(
          bottom: BorderSide(
              color: Constant.bgColor!,
              width: 3
          )
      ),
      title:Center(
        child: Row(
          mainAxisAlignment:showFilter==true?MainAxisAlignment.spaceBetween :MainAxisAlignment.spaceAround,
          children: [
            SizedBox(

                width: 80,
                child: GestureDetector(
                  onTap: () {
                    Get.offAllNamed('/home');
                  },
                  child: Hero(
                    tag: 'logo',
                    child: SvgPicture.asset('assets/imgs/logo.svg',
                        width: (Get.width * 0.18) <= 100 ? Get.width * 0.18: 200),
                  ),
                )),
            if(showFilter==true)
            SizedBox(
              height: 40,

              width: Get.width*0.5,
              child: TextField(
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.search,

                onSubmitted: (value) {
                  homeController.searchValue(value);
                  if (value != '') {
                    homeController.postSearch(value);
                  } else {
                    homeController.getHome();
                  }
                },
                style: TextStyle(color: Constant.dark,height:1,fontSize: Constant.fontSize),
                decoration: InputDecoration(
                  hoverColor: Constant.mainColor,
                  isDense: true,
                  hintStyle: TextStyle(color: Constant.dark,),
                  filled: true,
                  fillColor:  Constant.bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search".tr,
                  prefixIcon:  Icon(Icons.search,size: Constant.iconSize),
                  prefixIconColor: Colors.grey,
                ),
              ),),
            if(showFilter==true)
            GestureDetector(
                onTap: () {
                  openBottomSheet();
                },
                child:  SvgPicture.asset('assets/imgs/filter.svg',
    width: 40)),

          ],
        ),
      ),
      centerTitle: true,

    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(100);
}