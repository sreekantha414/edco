import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/OtpScreen/otp_screen.dart';
import 'package:award_maker/Screens/SignUpScreen/Bloc/check_email_bloc.dart';
import 'package:award_maker/Screens/SignUpScreen/Bloc/sign_up_bloc.dart';
import 'package:award_maker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Widget/app_button.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Text('SIGN UP', style: TextStyle(color: Colors.black, fontSize: 28.sp, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameC,
                        decoration: const InputDecoration(hintText: 'Name', border: UnderlineInputBorder()),
                        validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: emailC,
                        decoration: const InputDecoration(hintText: 'Email', border: UnderlineInputBorder()),
                        validator: (val) => val == null || val.isEmpty ? 'Please enter email' : null,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: passwordC,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Please enter password' : null,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: confirmPasswordC,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Confirm Password', border: UnderlineInputBorder()),
                        validator: (val) => val == null || val.isEmpty ? 'Please enter password' : null,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              BlocConsumer<SignUpBloc, SignUpState>(
                listener: (context, signUpState) {
                  if (signUpState.isCompleted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => OTPVerificationScreen(userId: signUpState.model?.result?.id, email: signUpState.model?.result?.email),
                      ),
                    );
                  } else if (signUpState.isFailed) {
                    AlertUtils.showToast(signUpState.responseMsg ?? '', context, AnimatedSnackBarType.error);
                  }
                },
                builder: (context, signUpState) {
                  return BlocConsumer<CheckEmailBloc, CheckEmailState>(
                    listener: (context, checkEmailState) {
                      if (checkEmailState.isCompleted) {
                        if (checkEmailState.model?.message == "Requested Data already exists") {
                          AlertUtils.showToast(checkEmailState.model?.message ?? '', context, AnimatedSnackBarType.error);
                        } else {
                          final body = {"name": nameC.text.trim(), "email": emailC.text.trim(), "password": passwordC.text.trim()};

                          signUp(body);
                        }
                      } else if (checkEmailState.isFailed) {
                        AlertUtils.showToast(signUpState.responseMsg ?? '', context, AnimatedSnackBarType.error);
                      }
                    },
                    builder: (context, checkEmailState) {
                      return AppButton(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        buttonName: 'SIGN UP',
                        buttonColor: Colors.blue,
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                        onPress: () {
                          // if (_formKey.currentState!.validate()) {
                          //   final body = {"name": nameC.text, "email": emailC.text, "password": passwordC.text};
                          //   signUp(body);
                          // }
                          checkEmail(emailC.text.trim());
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Colors.black, fontSize: 14.sp, fontFamily: "Poppins_Bold")),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Login",
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

  Future<void> signUp(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<SignUpBloc>(context).add(PerformSignUpEvent(data: data));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> checkEmail(String? email) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<CheckEmailBloc>(context).add(PerformCheckEmailEvent(email: email));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
