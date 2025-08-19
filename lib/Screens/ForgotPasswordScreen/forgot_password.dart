import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/LoginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Screens/OtpScreen/otp_screen.dart';
import '../../Widget/app_button.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';
import '../LoginScreen/Bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);

        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFAF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFCFAF7),
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
              }),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Forgot Password', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter email address to get the OTP to reset your password',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter email';
                          } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(val)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, forgotPasswordState) {
                  if (forgotPasswordState.isCompleted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OTPVerificationScreen(
                                  email: emailC.text.trim(),
                                  isFromSignIn: false,
                                )));
                  } else if (forgotPasswordState.isFailed) {
                    AlertUtils.showToast(forgotPasswordState.responseMsg ?? 'Something went wrong', context, AnimatedSnackBarType.error);
                  }
                },
                builder: (context, forgotPasswordState) {
                  return AppButton(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    buttonName: 'SUBMIT',
                    buttonColor: Colors.blue,
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        final body = {"email": emailC.text.trim()};
                        forgotPassWord(body);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> forgotPassWord(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<ForgotPasswordBloc>(context).add(PerformForgotPasswordEvent(data: data));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
