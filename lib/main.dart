import 'dart:convert';
import 'package:award_maker/Screens/HomeScreen/BLOC/award_list_bloc.dart';
import 'package:award_maker/Screens/LoginScreen/Bloc/login_bloc.dart';
import 'package:award_maker/utils/app_dependencies.dart';
import 'package:award_maker/utils/app_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Push_Notification/notification.dart';
import 'Screens/AwardDetailScreen/Bloc/award_detail_bloc.dart';
import 'Screens/Categories/Bloc/categories_bloc.dart';
import 'Screens/Change Password/Bloc/change_password_bloc.dart';
import 'Screens/DrawerScreen/Bloc/edit_profile_bloc.dart';
import 'Screens/HomeScreen/BLOC/favorite_list_bloc.dart';
import 'Screens/HomeScreen/BLOC/set_favorite_bloc.dart';
import 'Screens/LoginScreen/Bloc/forgot_password_bloc.dart';
import 'Screens/Notification/Bloc/notification_list_bloc.dart';
import 'Screens/OtpScreen/Bloc/resend_otp_bloc.dart';
import 'Screens/OtpScreen/Bloc/verify_otp_bloc.dart';
import 'Screens/SearchScreen/Bloc/search_bloc.dart';
import 'Screens/Settings/Bloc/notification_toggle_bloc.dart';
import 'Screens/SignUpScreen/Bloc/check_email_bloc.dart';
import 'Screens/SignUpScreen/Bloc/sign_up_bloc.dart';
import 'Screens/SignUpScreen/Model/SignUpModel.dart';
import 'Screens/SplahScreen/splash_screen.dart';

Logger logger = Logger();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBxJbEDSL1WB7lOVuYVPr2ws_YsNSFjx8E",
      appId: "1:367424942344:android:452d56e19e0f40e94b3cbd",
      messagingSenderId: "367424942344",
      projectId: "award-maker-by-edco",
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  setupDependencies();
  DeviceData deviceData = await AppHelper.getDeviceData();
  logger.w(deviceData.toJson());

  // Save to shared preferences if needed
  await saveToPrefs(deviceData);
  runApp(const MyApp());
}

Future<void> saveToPrefs(dynamic data) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonStr = jsonEncode(data);
  await prefs.setString('deviceData', jsonStr);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
        BlocProvider<AwardListBloc>(create: (_) => AwardListBloc()),
        BlocProvider<SignUpBloc>(create: (_) => SignUpBloc()),
        BlocProvider<CategoriesBloc>(create: (_) => CategoriesBloc()),
        BlocProvider<VerifyOtpBloc>(create: (_) => VerifyOtpBloc()),
        BlocProvider<ResendOtpBloc>(create: (_) => ResendOtpBloc()),
        BlocProvider<ForgotPasswordBloc>(create: (_) => ForgotPasswordBloc()),
        BlocProvider<NotificationToggleBloc>(create: (_) => NotificationToggleBloc()),
        BlocProvider<NotificationListBloc>(create: (_) => NotificationListBloc()),
        BlocProvider<EditProfileBloc>(create: (_) => EditProfileBloc()),
        BlocProvider<SetFavoriteBloc>(create: (_) => SetFavoriteBloc()),
        BlocProvider<FavoriteListBloc>(create: (_) => FavoriteListBloc()),
        BlocProvider<AwardDetailBloc>(create: (_) => AwardDetailBloc()),
        BlocProvider<ChangePasswordBloc>(create: (_) => ChangePasswordBloc()),
        BlocProvider<CheckEmailBloc>(create: (_) => CheckEmailBloc()),
        BlocProvider<SearchBloc>(create: (_) => SearchBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()),
      ),
    );
  }
}
