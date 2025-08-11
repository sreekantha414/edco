import 'dart:io';

import 'package:award_maker/Screens/WelcomeScreen/welcome_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../Screens/SignUpScreen/Model/SignUpModel.dart';

class AppHelper {
  static void showLogoutConfirmationDialog(BuildContext context) {
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
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        await pref.clear();
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                      },
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
                        Navigator.of(context).pop(); // Logout logic goes here
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
    // String? deviceToken = await FirebaseMessaging.instance.getToken();
    String? deviceToken = '';
    return DeviceData(deviceType: deviceType, deviceToken: deviceToken, deviceId: deviceId, deviceName: deviceName);
  }
}
