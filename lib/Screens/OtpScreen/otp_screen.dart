import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/Change%20Password/chnage_password.dart';
import 'package:award_maker/Screens/LoginScreen/login_screen.dart';
import 'package:award_maker/Screens/OtpScreen/Bloc/resend_otp_bloc.dart';
import 'package:award_maker/Screens/OtpScreen/Bloc/verify_otp_bloc.dart';
import 'package:award_maker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Widget/app_button.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_helper.dart';
import '../../utils/app_utils.dart';
import '../SignUpScreen/Model/SignUpModel.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String? userId;
  final String? email;
  final bool? isFromSignIn;

  const OTPVerificationScreen({super.key, this.userId, this.email, this.isFromSignIn});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late Timer _timer;
  int _secondsRemaining = 120;
  bool _showResend = false;
  TextEditingController pinController = TextEditingController();
  DeviceData? deviceData;

  @override
  void initState() {
    super.initState();
    startTimer();
    inItData();
  }

  void inItData() async {
    DeviceData deviceData = await AppHelper.getDeviceData();
    logger.w(deviceData.toJson());
  }

  void startTimer() {
    setState(() {
      _secondsRemaining = 120;
      _showResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _showResend = true);
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF7),
      appBar: AppBar(backgroundColor: const Color(0xFFFCFAF7), elevation: 0, leading: const BackButton(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('OTP VERIFICATION', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10.w),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter Otp sent your registered email', style: const TextStyle(fontSize: 14, color: Colors.black)),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PinCodeTextField(
                      controller: pinController,
                      appContext: context,
                      length: 4,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeColor: Colors.blue,
                        selectedColor: Colors.blue,
                        inactiveColor: Colors.black26,
                      ),
                      cursorColor: Colors.black,
                      textStyle: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 4) {
                          var body = {"email": widget.email, "otp": value};
                          verifyOtp(body);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Didn't received code? ", style: TextStyle(fontSize: 14, color: Colors.black54)),
                _showResend
                    ? GestureDetector(
                        onTap: () {
                          final body = {"email": widget.email, "type": widget.isFromSignIn == true ? "VERIFY_EMAIL" : "FORGOT_PASSWORD"};
                          reSendOtp(body);
                          startTimer();
                          pinController.clear();
                        },
                        child: const Text("Resend", style: TextStyle(fontSize: 14, color: Color(0xFF0B60B0), fontWeight: FontWeight.w500)),
                      )
                    : Row(
                        children: [
                          Text('Request new otp in', style: const TextStyle(fontSize: 14, color: Colors.black)),
                          SizedBox(width: 10.w),
                          Text('${formatTimer(_secondsRemaining)}',
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                        ],
                      ),
              ],
            ),
            const SizedBox(height: 30),
            BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
              listener: (context, verifyOtpState) {
                if (verifyOtpState.isCompleted) {
                  if (widget.isFromSignIn == true) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
                    AlertUtils.showToast("Otp Verified Successfully" ?? '', context, AnimatedSnackBarType.success);
                  } else {
                    logger.w(verifyOtpState.model?.result?.token ?? '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChangePasswordScreen(token: verifyOtpState.model?.result?.token)),
                    );
                  }
                } else if (verifyOtpState.isFailed) {
                  AlertUtils.showToast(verifyOtpState.responseMsg ?? '', context, AnimatedSnackBarType.error);
                }
              },
              builder: (context, verifyOtpState) {
                return AppButton(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  buttonName: 'SUBMIT',
                  buttonColor: Colors.blue,
                  style: TextStyle(fontSize: 14.sp, color: Colors.white, fontFamily: "Poppins_Bold"),
                  onPress: () {
                    if (widget.isFromSignIn == true) {
                      var body = {"email": widget.email, "otp": pinController.text.trim(), "deviceData": deviceData?.toJson()};
                      verifyOtp(body);
                    } else {
                      var body = {"email": widget.email, "otp": pinController.text.trim()};
                      verifyOtp(body);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyOtp(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<VerifyOtpBloc>(context).add(PerformVerifyOtpEvent(data: data, id: widget.userId));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> reSendOtp(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<ResendOtpBloc>(context).add(PerformResendOtpEvent(data: data, id: widget.userId));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
