import 'package:dhile/main.dart';
import 'package:dhile/pages/book.dart';
import 'package:dhile/pages/brand_details.dart';
import 'package:dhile/pages/brand.dart';
import 'package:dhile/pages/car_details.dart';
import 'package:dhile/pages/checkout.dart';
import 'package:dhile/pages/faild.dart';
import 'package:dhile/pages/faq.dart';
import 'package:dhile/pages/home.dart';
import 'package:dhile/pages/offers_details.dart';
import 'package:dhile/pages/settings.dart';
import 'package:dhile/pages/thank-you.dart';
import 'package:get/get.dart';



class AppRoute {



  List<GetPage> ? routeArray;

  AppRoute();

  void getRoute()async{

    routeArray=[


      GetPage(
          name: '/',
          page: ()=>MyApp(),
          // transition: Transition.cupertinoDialog
      ),
      GetPage(
          name: '/home',
          page: ()=>const HomePage(),
          transition: Transition.fadeIn
      ),
      GetPage(
          name: '/faq',
          page: ()=>const FaqPage(),
          transition: Transition.fadeIn
      ), GetPage(
          name: '/settings',
          page: ()=>const SettingsPage(),
          transition: Transition.fadeIn
      ),
      GetPage(
          name: '/brand',
          page: ()=>const BrandPage(),
          transition: Transition.fadeIn
      ),
      GetPage(
          name: '/brandDetails',
          page: (){

           return  BrandDetailsPage(brand: Get.arguments[0],);
          },
          transition: Transition.fadeIn
      ),

      GetPage(
          name: '/carDetails',
          page: (){

           return  CarDetailsPage(car: Get.arguments[0],);
          },
          transition: Transition.fadeIn
      ),
      GetPage(
          name: '/book',
          page: (){
           return  BookPage(car: Get.arguments[0],);
          },
          transition: Transition.downToUp
      ), GetPage(
          name: '/offers',
          page: (){
           return  const OfferDetailsPage();
          },
          transition: Transition.fadeIn
      ),
      GetPage(
          name: '/thank',
          page: (){
           return  const ThankPage();
          },
          transition: Transition.downToUp
      ),
      GetPage(
          name: '/checkout',
          page: (){
            return  CheckOutPage(initialUrl: Get.arguments[0]);
          },
          transition: Transition.downToUp
      ),GetPage(
          name: '/fail',
          page: (){
            return  const FailPage();
          },
          transition: Transition.downToUp
      )
    ];
  }
}