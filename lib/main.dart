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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,overlays: []);
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  LocalNoti.initialize(flutterLocalNotificationsPlugin);
  FlutterAppBadger.removeBadge();
  String  x='{"image": "https://phplaravel-548447-4346140.cloudwaysapps.com/uploads/car/03lHXwUhoKtTBc79kI4pQDxIEqxApPRO9FwKfmYc.png", "id": "18", "brand": "https://phplaravel-548447-4346140.cloudwaysapps.com/uploads/car/03lHXwUhoKtTBc79kI4pQDxIEqxApPRO9FwKfmYc.png"}';
  LocalNoti.showBigTextNotification(title: 'test', body: 'bodyyy',payload:  jsonDecode(x), fln: flutterLocalNotificationsPlugin);
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
    await FirebaseMessaging.instance.getInitialMessage();

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
    NotificationModel notificationModel = notificationFromJson(jsonEncode(message.data));
    Get.offAllNamed('/carNotificationDetails', arguments: [notificationModel.id]);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupInteractedMessage();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    FlutterSecureStorage storage = const FlutterSecureStorage();


    AppRoute data = AppRoute();
    data.getRoute();

    return GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/',
        debugShowCheckedModeBanner  : false,
        defaultTransition: Transition.zoom,
        getPages:  data.routeArray,
        translations: Lang(),
        locale: const Locale('en','US'),
        fallbackLocale: const Locale('en','US'),
       theme: ThemeData(
         fontFamily: 'din',
         primaryColorLight: Constant.mainColor,
         primaryColor: Constant.mainColor,
           textSelectionTheme: TextSelectionThemeData(
               selectionColor: Constant.mainColor,
           cursorColor: Constant.mainColor,selectionHandleColor: Constant.mainColor),
       ),
        themeMode: ThemeMode.light,
        initialBinding: HomeControllerBinding(),
        title: "AL-Dhile",
        home:AnimatedSplashScreen.withScreenFunction(
          splashIconSize: 300,
          splash: 'assets/imgs/intro.gif',
          screenFunction: () async{
            // HomeController homeController = HomeController();
            final String defaultLocale = Platform.localeName.toString().substring(0,2);
          Locale localLang= await storage.read(key: 'lang')==null ?defaultLocale=='ar'?const Locale('ar','SA'): const Locale('en','US'):await storage.read(key: 'lang')=='ar'? const Locale('ar','SA'):const Locale('en','US');
            Get.updateLocale(localLang);
            await storage.deleteAll();
            await storage.write(key: "lang", value:localLang.toString().substring(0,2));
            // await homeController.getHome();
            return   const HomePage();
          },
          backgroundColor: Colors.white,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
        )
    );
  }
}

