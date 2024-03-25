import 'package:dhile/constant.dart';
import 'package:dhile/controller/home_controller.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:dhile/widgets/bottom_nav.dart';
import 'package:dhile/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class OfferDetailsPage extends StatefulWidget {

  const OfferDetailsPage(
      {super.key,});

  @override
  State<OfferDetailsPage> createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {

  HomeController homeController = HomeController();

  Future getData() async {
    await homeController.fetchByOffers();
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
        appBar: const AppBarCustom(showFilter: false),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15,),
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
                    if(homeController.cars.value!=null) {
                      return Padding(
                        padding: const EdgeInsets.only( left: 15, right: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [



                            Text('Enjoy Car Rental Offers'.tr,
                                style: TextStyle(
                                    color: Constant.dark,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),

                            const SizedBox(height: 10),
                            Expanded(
                              child:  RefreshIndicator(
                                  color: Constant.mainColor,
                                  onRefresh:() async{
                                    await homeController.storage.delete(key: "offers");
                                    await homeController.fetchByOffers();
                                  },
                                  child:CarCard(homeController: homeController)),
                            )
                          ],
                        ),
                      );
                    }else{
                      return Center(
                        child: Text('No Car Found!'.tr,style: TextStyle(fontSize: 20,color: Constant.dark)),
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
          index: 1,
        ));
  }
}
