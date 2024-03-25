import 'package:dhile/controller/setting_controller.dart';
import 'package:dhile/widgets/app_bar.dart';
import 'package:dhile/widgets/bottom_nav.dart';
import 'package:dhile/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsController settingsController = SettingsController();

  Future getData() async {
    await settingsController.getSocial();
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
    FlutterSecureStorage storage = const FlutterSecureStorage();
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
                Text('Settings'.tr,
                    style: TextStyle(
                        color: Constant.dark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (settingsController.isLoading.value == true) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Constant.mainColor,
                        ),
                      );
                    } else {
                      if (settingsController.isFail.value == false) {
                        DateTime now = new DateTime.now();
                        DateTime date = new DateTime(now.year);
                        final social = <Widget>[];
                        String? whats;
                        String? phone;
                        if (settingsController.contactModel.value != null) {
                          for (var x = 0;
                          x <
                              settingsController
                                  .contactModel.value!.contact.length;
                          x++) {
                            if (settingsController
                                .contactModel.value!.contact[x].type ==
                                'mobile') {
                              phone = settingsController
                                  .contactModel.value!.contact[x].url;
                            } else if (settingsController
                                .contactModel.value!.contact[x].type ==
                                'whatsapp') {
                              whats = settingsController
                                  .contactModel.value!.contact[x].url;
                            }
                          }
                        }
                        if (settingsController.socialModel.value != null) {
                          for (int x = 0;
                          x <
                              settingsController
                                  .socialModel.value!.social.length;
                          x++) {
                            if (settingsController
                                .socialModel.value!.social[x].icon ==
                                'facebook') {
                              social.add(GestureDetector(
                                onTap: () {
                                  launchUrlString(settingsController
                                      .socialModel.value!.social[x].url);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  child: FaIcon(FontAwesomeIcons.facebookF),
                                ),
                              ));
                            } else if (settingsController
                                .socialModel.value!.social[x].icon ==
                                'youtube') {
                              social.add(GestureDetector(
                                onTap: () {
                                  launchUrlString(settingsController
                                      .socialModel.value!.social[x].url);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  child: FaIcon(FontAwesomeIcons.youtube),
                                ),
                              ));
                            } else if (settingsController
                                .socialModel.value!.social[x].icon ==
                                'x' ||
                                settingsController
                                    .socialModel.value!.social[x].icon ==
                                    'twitter') {
                              social.add(GestureDetector(
                                onTap: () {
                                  launchUrlString(settingsController
                                      .socialModel.value!.social[x].url);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  child: FaIcon(FontAwesomeIcons.xTwitter),
                                ),
                              ));
                            } else if (settingsController
                                .socialModel.value!.social[x].icon ==
                                'instagram') {
                              social.add(GestureDetector(
                                onTap: () {
                                  launchUrlString(settingsController
                                      .socialModel.value!.social[x].url);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  child: FaIcon(FontAwesomeIcons.instagram),
                                ),
                              ));
                            } else if (settingsController
                                .socialModel.value!.social[x].icon ==
                                'linkedin') {
                              social.add(GestureDetector(
                                onTap: () {
                                  launchUrlString(settingsController
                                      .socialModel.value!.social[x].url);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  child: FaIcon(FontAwesomeIcons.linkedinIn),
                                ),
                              ));
                            } else if (settingsController
                                .socialModel.value!.social[x].icon ==
                                'tiktok') {
                              social.add(GestureDetector(
                                onTap: () {
                                  launchUrlString(settingsController
                                      .socialModel.value!.social[x].url);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20),
                                  child: FaIcon(FontAwesomeIcons.tiktok),
                                ),
                              ));
                            }
                          }
                        }

                        return RefreshIndicator(
                          color: Constant.mainColor,
                          onRefresh: () async {
                            await settingsController.storage
                                .delete(key: "social");
                            await settingsController.getSocial();
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (Get.locale.toString().substring(0, 2) !=
                                        'ar') {
                                      Get.updateLocale(
                                          const Locale('ar', 'SA'));
                                    } else {
                                      Get.updateLocale(
                                          const Locale('en', 'US'));
                                    }
                                    await storage.deleteAll();
                                    Locale localLang =
                                    Get.locale.toString().substring(0, 2) !=
                                        'ar'
                                        ? const Locale('en', 'US')
                                        : const Locale('ar', 'SA');
                                    await storage.write(
                                        key: "lang",
                                        value:
                                        localLang.toString().substring(0, 2));
                                    settingsController.getSocial();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Language'.tr,
                                            style: TextStyle(
                                                color: Constant.iconColor,
                                                fontSize: 22),
                                          ),
                                          FaIcon(
                                            Get.locale
                                                .toString()
                                                .substring(0, 2) !=
                                                'ar'
                                                ? FontAwesomeIcons.angleRight
                                                : FontAwesomeIcons.angleLeft,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'lang'.tr,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (phone != null)
                                  GestureDetector(
                                    onTap: () async {
                                      launchUrlString(phone!);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Call Us'.tr,
                                              style: TextStyle(
                                                  color: Constant.iconColor,
                                                  fontSize: 22),
                                            ),
                                            FaIcon(
                                              Get.locale
                                                  .toString()
                                                  .substring(0, 2) !=
                                                  'ar'
                                                  ? FontAwesomeIcons.angleRight
                                                  : FontAwesomeIcons.angleLeft,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Divider(
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (phone != null)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                GestureDetector(
                                  onTap: () async {
                                    launchUrlString('${Constant.domain}terms');
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Terms'.tr,
                                            style: TextStyle(
                                                color: Constant.iconColor,
                                                fontSize: 22),
                                          ),
                                          FaIcon(
                                            Get.locale
                                                .toString()
                                                .substring(0, 2) !=
                                                'ar'
                                                ? FontAwesomeIcons.angleRight
                                                : FontAwesomeIcons.angleLeft,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (whats != null)
                                  GestureDetector(
                                    onTap: () async {
                                      launchUrlString(whats!);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Chat On Whatsapp'.tr,
                                              style: TextStyle(
                                                  color: Constant.iconColor,
                                                  fontSize: 22),
                                            ),
                                            FaIcon(
                                              Get.locale
                                                  .toString()
                                                  .substring(0, 2) !=
                                                  'ar'
                                                  ? FontAwesomeIcons.angleRight
                                                  : FontAwesomeIcons.angleLeft,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Divider(
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (whats != null)
                                  const SizedBox(
                                    height: 40,
                                  ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: social,
                                ),
                                const SizedBox(height: 25,),
                                GestureDetector(
                                  onTap: () {
                                    launchUrlString('https://www.maxart.ae/');
                                  },
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.copyright,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      Text('${date.year} ${'Developed By Maxart'
                                          .tr}', style: const TextStyle(
                                          color: Colors.grey),)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text('Connection Error'.tr, style: TextStyle(
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
          index: 4,
        ));
  }
}
