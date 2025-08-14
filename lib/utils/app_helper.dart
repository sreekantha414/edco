import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/WelcomeScreen/welcome_screen.dart';
import 'package:award_maker/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../Screens/SignUpScreen/Model/SignUpModel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Widget/webview_widget.dart';
import '../api_client/dio_client.dart';
import '../constants/app_constants.dart';
import 'alert_utils.dart';

class AppHelper {
  static void showLogoutConfirmationDialog(BuildContext context, void Function()? onTap) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 180.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: Colors.white),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Confirm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Poppins_Bold')),
              const SizedBox(height: 12),
              const Text(
                'Confirm you want to logout ?',
                style: TextStyle(fontSize: 14, color: Colors.black54, fontFamily: 'Poppins_Regular'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // YES BUTTON
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0057B8)),
                        foregroundColor: Color(0xFF0057B8),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Yes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Poppins_SemiBold')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // NO BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0057B8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('No', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Poppins_SemiBold')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<DeviceData> getDeviceData() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final uuid = Uuid();

    String? deviceName;
    String? deviceId;
    String deviceType = Platform.isAndroid ? "android" : "ios";

    // Get device name and ID
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = "${androidInfo.manufacturer} ${androidInfo.model}";
      deviceId = androidInfo.id ?? uuid.v4(); // fallback if null
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name;
      deviceId = iosInfo.identifierForVendor ?? uuid.v4(); // fallback if null
    }

    // Get FCM token (push notification token)
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    return DeviceData(deviceType: deviceType, deviceToken: deviceToken, deviceId: deviceId, deviceName: deviceName);
  }

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.edco.com/api/v1/",
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<Map<String, dynamic>?> signInWithGoogle(BuildContext context) async {
    try {
      // Step 1: Google sign-in flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['email', 'profile']).signIn();
      if (googleUser == null) return null; // User canceled
      DeviceData? loadedData;
      DeviceData deviceData = await AppHelper.getDeviceData();
      logger.w(deviceData.toJson());
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.accessToken;
      logger.w(googleUser.email);
      if (idToken == null) return null;
      logger.w(idToken);

      // Step 2: Create request body
      final Map<String, dynamic> loginData = {
        "loginType": 3,
        "loginToken": idToken,
        "isSocialVerified": true,
        "name": googleUser.displayName ?? "",
        "email": googleUser.email,
        "deviceData": deviceData.toJson(),
      };

      logger.w(loginData);
      // Step 3: Send to backend
      final response = await _dio.post(
        "https://api.edco.com/api/v1/login",
        data: loginData,
        options: Options(headers: {"Authorization": basicAuthHeader('trophy_usr', 'hjGGHTy}}78'), "Content-Type": "application/json"}),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data;
      } else {
        final errorMessage = response.data['message'] ?? "Login failed, please try again.";
        AlertUtils.showToast(errorMessage, context, AnimatedSnackBarType.error);
      }
      logger.w(response.data);
      return response.data;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }

  static Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    await googleSignIn.disconnect();
  }
}
