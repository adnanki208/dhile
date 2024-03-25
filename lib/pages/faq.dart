import 'package:dhile/controller/faq_controller.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:dhile/widgets/bottom_nav.dart';
import 'package:dhile/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';
import 'package:get/get.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  FaqController faqController = FaqController();

  Future getData() async {
    await faqController.getFaq();
    // print(homeController.data.cars[0].brands.name);
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
        body: Container(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15, bottom: 5, top: 5),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Every thing You Need To Know!'.tr,
                    style: TextStyle(
                        color: Constant.dark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text('Browse The Information'.tr,
                    style: TextStyle(color: Constant.dark, fontSize: 14),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (faqController.isLoading.value == true) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Constant.mainColor,
                        ),
                      );
                    } else {
                      if (faqController.isFail.value == false) {
                        if (faqController.faqModel.value != null) {
                          return RefreshIndicator(
                              color: Constant.mainColor,
                              onRefresh: () async {
                                await faqController.storage.delete(key: "faq");
                                await faqController.getFaq();
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                      faqController.faqModel.value!.faq.length,
                                      (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: EasyFaq(
                                        anserTextStyle: TextStyle(
                                            fontSize: Constant.fontSize),
                                        questionTextStyle: TextStyle(
                                            fontSize: Constant.fontSize,
                                            fontWeight: FontWeight.bold),
                                        question: faqController.faqModel.value!
                                            .faq[index].question,
                                        answer: faqController.faqModel.value!
                                            .faq[index].answer,
                                        backgroundColor: Constant.bgColor,
                                        expandedIcon: Icon(
                                          Icons.remove,
                                          color: Constant.mainColor,
                                          size: Constant.iconSize,
                                        ),
                                        collapsedIcon: Icon(
                                          Icons.add,
                                          color: Constant.mainColor,
                                          size: Constant.iconSize,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
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
          index: 3,
        ));
  }
}
