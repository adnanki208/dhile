import 'dart:convert';
import 'package:dhile/constant.dart';
import 'package:dhile/models/notification.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // LocalNoti.showBigTextNotification(title: message.notification?.title??'', body: message.notification?.body??'', fln: flutterLocalNotificationsPlugin);
  // print('title:${message.notification?.title}');
  // print('body:${message.notification?.body}');
  // print('title:${message.data}');
}


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> initNotifications() async {

     await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();
    // print(settings.authorizationStatus);
    // print('-------------------------------------------');
    // print(fCMToken);
    await _firebaseMessaging.subscribeToTopic('dhile');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      LocalNoti.showBigTextNotification(title:'${message.notification?.title}'.tr??"", body: '${message.notification?.body}'.tr??"",payload: message.data, fln: flutterLocalNotificationsPlugin);
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      NotificationModel notificationModel = notificationFromJson(jsonEncode(event.data));
      Get.offAllNamed('/carNotificationDetails',arguments:[notificationModel.id]);
    });


//     await FirebaseMessaging.instance.getInitialMessage().then((value) {
//
//       // if(value!=null) {
//       //   print('xxxxxxxxxxxxxxxxxx');
//       //   print(value);
//       //   print(value.data);
//       //   NotificationModel notificationModel = notificationFromJson(jsonEncode(value.data));
//       //   Get.offAllNamed('/carNotificationDetails', arguments: [notificationModel.id]);
//       // }else{
//       //   return null;
//       // }
// print('xxxxx');
//     });
    }
}

class LocalNoti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInitialize = DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details){

        NotificationModel notificationModel = notificationFromJson(details.payload!);
        Get.offAllNamed('/carNotificationDetails',arguments:[notificationModel.id]);


      },
    );

  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
   NotificationModel notificationModel = notificationFromJson(jsonEncode(payload));
   final http.Response response = await http.get(Uri.parse('${Constant.domain}${notificationModel.image}'));
   final http.Response brand = await http.get(Uri.parse('${Constant.domain}${notificationModel.brand}'));
    AndroidNotificationDetails androidPlatformChannelSpecifics =
         AndroidNotificationDetails(
      'noti',
      'channelName',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
          styleInformation:   BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(brand.bodyBytes)),
          )
    );
    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());
    await fln.show(0, title, body, not,payload: jsonEncode(payload));
  }
}