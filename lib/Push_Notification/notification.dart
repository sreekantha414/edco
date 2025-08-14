import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../main.dart';

///notification step need to follow
///1  add this below section in your android manifest file
/// <meta-data
///                 android:name="com.google.firebase.messaging.default_notification_icon"
///                 android:resource="@drawable/ic_notification" />
///
///             <meta-data
///                 android:name="com.google.firebase.messaging.default_notification_channel_id"
///                 android:resource="@string/default_notification_channel_id" />
///
/// 2 add black end white icon in drawable folder with ic_notification.png
/// 3 past this file in your code
/// 4 add below line in splace screen
/// final PushNotificationService _notificationService = PushNotificationService();
/// add in initstate of splace screen
///  _notificationService.initialize();
class PushNotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  Future initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'fcm_fallback_notification_channel', // id
      'Miscellaneous', // title
      importance: Importance.high,
      ledColor: Colors.orange,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    int i = 1;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const topic = 'app_promotion';
    await _fcm.subscribeToTopic(topic);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      // StreamUtil.notificationCount.add(StreamUtil.notificationCount.value + 1);
      print('Message data: ${message.notification!.title} ${message.notification!.body}');
      try {
        RemoteNotification? notification = message.notification;
        String imageUrl = '';
        BigPictureStyleInformation? bigPictureStyleInformation;
        if (message.data != null) {
          imageUrl = message.data['image'] ?? '';
        } else {
          imageUrl = notification!.toMap()['image'] ?? '';
        }
        if (imageUrl != '') {
          final http.Response response = await http.get(Uri.parse(imageUrl));
          bigPictureStyleInformation = BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
          );
        }

        print('Notification $i ${message.notification?.toMap()}');
        i = i + 1;
        print('NOTIFICATION_DATATAATAA** ${message.notification?.body}');

        flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'fcm_fallback_notification_channel',
              'Miscellaneous',
              //   channel?.description ?? '',
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'ic_launcher',
              importance: Importance.high,
              enableVibration: true,
              enableLights: true,
              styleInformation: bigPictureStyleInformation,
            ),
            iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
          ),
        );
      } catch (e) {
        print('ERROR SHOW NOTIFICATION ${e.toString()}');
      }
    });

    //FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // Get the token
    await getDeviceData();
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }

  Future getDeviceData() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String? token = await _fcm.getToken() ?? '';
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.toMap();
    print('All Info ${allInfo.toString()}');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String? osVersion;
    String? deviceCompany;
    String? model;
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        osVersion = build.version.sdkInt.toString(); //UUID for Android
        deviceCompany = '${build.manufacturer} - ${build.brand}';
        model = build.model;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        osVersion = data.systemVersion;
        deviceCompany = 'Apple - ${data.utsname.machine}';
        model = data.model;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    Map<String, dynamic> data = {
      "deviceId": '',
      "fcmToken": token,
      "deviceCompany": deviceCompany,
      "deviceName": model,
      "os": Platform.isAndroid ? 'android' : 'ios',
      "appVersion": packageInfo.version.toString(),
      "osVersion": osVersion,
    };
    logger.d(data);
    // await prefs?.setString(AppConstants.fcmToken, token);
    // await prefs?.setString(AppConstants.deviceId, deviceId);
    // String deviceData = jsonEncode(data);
    // await prefs?.setString(AppConstants.deviceData, deviceData);
  }
}
