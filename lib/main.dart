import 'package:dhile/constant.dart';
import 'package:dhile/controller/HomeControllerBinding.dart';
import 'package:dhile/lang/lang.dart';
import 'package:dhile/pages/home.dart';
import 'package:dhile/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

