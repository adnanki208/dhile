import 'dart:convert';
import 'package:dhile/api/firebase_api.dart';
import 'package:dhile/constant.dart';
import 'package:dhile/controller/HomeControllerBinding.dart';
import 'package:dhile/lang/lang.dart';
import 'package:dhile/models/notification.dart';
import 'package:dhile/pages/home.dart';
import 'package:dhile/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final firebaseMessaging = FirebaseMessaging.instance;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,overlays: []);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await firebaseMessaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // print(message.data);
    NotificationModel notificationModel =
        notificationFromJson(jsonEncode(message.data));
    Get.offAllNamed('/carNotificationDetails',
        arguments: [notificationModel.id]);
  }

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    FlutterAppBadger.removeBadge();
    AppRoute data = AppRoute();
    data.getRoute();

    return GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.zoom,
        getPages: data.routeArray,
        translations: Lang(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeData(
          fontFamily: 'din',
          primaryColorLight: Constant.mainColor,
          primaryColor: Constant.mainColor,
          textSelectionTheme: TextSelectionThemeData(
              selectionColor: Constant.mainColor,
              cursorColor: Constant.mainColor,
              selectionHandleColor: Constant.mainColor),
        ),
        themeMode: ThemeMode.light,
        initialBinding: HomeControllerBinding(),
        title: "AL-Dhile",
        home: AnimatedSplashScreen.withScreenFunction(
          splashIconSize: 300,
          splash: 'assets/imgs/intro.gif',
          screenFunction: () async{
            await Firebase.initializeApp();
            await FirebaseApi().initNotifications(firebaseMessaging);
            LocalNoti.initialize(flutterLocalNotificationsPlugin);
            setupInteractedMessage();

            return const HomePage();
          },
          // nextScreen:const HomePage(),
          backgroundColor: Colors.white,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
        ));
  }
}
