import 'package:dhile/controller/brand_controller.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:dhile/widgets/bottom_nav.dart';
import 'package:dhile/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  BrandController brandController = BrandController();

  Future getData() async {
    await brandController.getBrands();
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
        appBar: const AppBarCustom(showFilter: false),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15, bottom: 5, top: 5),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Find Your Brand!'.tr,
                    style: TextStyle(
                        color: Constant.dark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Expanded(
                  child: Obx(() {
                    if (brandController.isLoading.value == true) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Constant.mainColor,
                        ),
                      );
                    } else {
                      if (brandController.isFail.value == false) {
                        if (brandController
                            .brandModel.value!=null) {
                          return RefreshIndicator(
                              color: Constant.mainColor,
                              onRefresh: () async {
                                await brandController.storage
                                    .delete(key: "brand");
                                await brandController.getBrands();
                              },
                              child: MasonryGridView.count(
                                crossAxisCount: MediaQuery.of(context)
                                            .size
                                            .width <=
                                        600
                                    ? 3
                                    : MediaQuery.of(context).size.width <= 1200
                                        ? 6
                                        : 9,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                itemCount: brandController
                                    .brandModel.value!.brands.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed('/brandDetails', arguments: [
                                        brandController
                                            .brandModel.value!.brands[index].id
                                      ]);
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
                                              width: 50,
                                              child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(
                                                          color: Colors.white),
                                                  imageUrl: Constant.domain +
                                                      brandController
                                                          .brandModel
                                                          .value!
                                                          .brands[index]
                                                          .mediaIconApi!
                                                          .url,
                                                  fit: BoxFit.fill),
                                            ),
                                            Text(brandController.brandModel
                                                .value!.brands[index].title),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ));
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Constant.mainColor,
                            ),
                          );
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
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNav(
          index: 0,
        ));
  }
}
