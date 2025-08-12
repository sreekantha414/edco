import 'package:award_maker/Screens/HomeScreen/HomeScreen.dart';
import 'package:award_maker/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Push_Notification/notification.dart';
import '../WelcomeScreen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late SharedPreferences prefs;
  bool? isLogin;
  final PushNotificationService _notificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();
    _initPrefsAndLoadDeviceData();
    _notificationService.initialize();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward();

    // Optional: Navigate after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (isLogin == true) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Homescreen()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomeScreen()), (route) => false);
      }
    });
  }

  Future<void> _initPrefsAndLoadDeviceData() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = await prefs.getBool('login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          SizedBox.expand(child: Image.asset(ImageAssetPath.splashBg, fit: BoxFit.cover)),
          // Animated Logo
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                ImageAssetPath.appLogoText,
                width: 200, // Final width
              ),
            ),
          ),
        ],
      ),
    );
  }
}
