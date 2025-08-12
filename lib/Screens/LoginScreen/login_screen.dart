import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/LoginScreen/Bloc/forgot_password_bloc.dart';
import 'package:award_maker/Screens/LoginScreen/Bloc/login_bloc.dart';
import 'package:award_maker/Screens/OtpScreen/otp_screen.dart';
import 'package:award_maker/Screens/SignUpScreen/sign_up_Screen.dart';
import 'package:award_maker/Widget/app_button.dart';
import 'package:award_maker/utils/alert_utils.dart';
import 'package:award_maker/utils/app_helper.dart';
import 'package:award_maker/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';
import '../../constants/asset_path.dart';
import '../../main.dart';
import '../ForgotPasswordScreen/forgot_password.dart';
import '../HomeScreen/HomeScreen.dart';
import '../SignUpScreen/Model/SignUpModel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  bool obscurePassword = true;
  Map<String, dynamic> deviceInfo = {};
  late SharedPreferences prefs;
  DeviceData? deviceData;

  @override
  void initState() {
    super.initState();
    _initPrefsAndLoadDeviceData();
  }

  Future<void> _initPrefsAndLoadDeviceData() async {
    deviceData = await AppHelper.getDeviceData();
    logger.w(deviceData?.toJson());
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Text('LOGIN', style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  icon: Image.asset(ImageAssetPath.google, height: 24),
                  label: const Text('Google', style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final result = await AppHelper.signInWithGoogle();
                    logger.w(result?['result']['authtoken']);

                    if (result != null) {
                      await prefs.setString('uid', result['result']['_id']);
                      await prefs.setString('uname', result['result']['name']);
                      await prefs.setString(AppConstants.token, result['result']['authtoken']);
                      await prefs.setBool('login', true);

                      var token = await prefs.getString(AppConstants.token);
                      logger.w(token);

                      AlertUtils.showToast('Login Successfully' ?? '', context, AnimatedSnackBarType.success);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Homescreen()));

                      print("Login success: $result");
                    } else {
                      print("Login failed or canceled");
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailC,
                        decoration: const InputDecoration(hintText: 'Email', border: UnderlineInputBorder()),
                        validator: (val) => val == null || val.isEmpty ? 'Please enter email' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordC,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() => obscurePassword = !obscurePassword);
                            },
                          ),
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Please enter password' : null,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                        },
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(color: Colors.blue, fontFamily: "Poppins_Bold", fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, loginState) async {
                  if (loginState.isCompleted) {
                    await prefs.setString('uid', loginState.model?.result?.id ?? '');
                    await prefs.setString('uname', loginState.model?.result?.name ?? '');
                    await prefs.setString(AppConstants.token, loginState.model?.result?.authtoken ?? '');

                    await prefs.setBool('login', true);
                    var uid = await prefs.getString('uid');
                    var uname = await prefs.getString('uname');
                    var token = await prefs.getString(AppConstants.token);

                    logger.w(uid);
                    logger.w(uname);
                    logger.w(token);

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Homescreen()), (route) => false);
                  } else if (loginState.isFailed) {
                    AlertUtils.showToast(loginState.responseMsg ?? '', context, AnimatedSnackBarType.error);
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    buttonName: 'LOGIN',
                    buttonColor: Colors.blue,
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        final body = {"email": emailC.text, "password": passwordC.text, "loginType": 1, "deviceData": deviceData?.toJson()};
                        login(body);
                      }

                      // final body = {"email": "sreekantha414@gmail.com", "password": "Admin@1234", "loginType": 1};
                      // login(body);
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account? ", style: TextStyle(color: Colors.black, fontSize: 14.sp, fontFamily: "Poppins_Bold")),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                    }, // or navigate to signup
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontFamily: "Poppins_Bold"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<LoginBloc>(context).add(PerformLoginEvent(data: data));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
