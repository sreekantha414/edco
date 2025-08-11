import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/Change%20Password/Bloc/change_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Widget/app_button.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String? token;
  const ChangePasswordScreen({super.key, this.token});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _oldPass = TextEditingController();
  TextEditingController _newPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF6), // Off-white/cream background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAF6),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CHANGE PASSWORD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      suffixIcon: Icon(Icons.info_outline, size: 20),
                      border: const UnderlineInputBorder(),
                    ),
                    controller: _oldPass,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _newPass,
                    decoration: const InputDecoration(labelText: 'New Password', border: UnderlineInputBorder()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
              listener: (context, changePasswordState) {
                if (changePasswordState.isCompleted) {
                  if (widget.token?.isNotEmpty == true || widget.token != null) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => ChangePasswordScreen()), (route) => false);
                    AlertUtils.showToast('Password Reset Successfully!' ?? '', context, AnimatedSnackBarType.success);
                  } else {
                    AlertUtils.showToast('Password updated!' ?? '', context, AnimatedSnackBarType.success);

                    Navigator.pop(context);
                  }
                } else if (changePasswordState.isFailed) {
                  AlertUtils.showToast(changePasswordState.responseMsg ?? '', context, AnimatedSnackBarType.error);
                }
              },
              builder: (context, changePasswordState) {
                return AppButton(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  buttonName: 'SUBMIT',
                  buttonColor: Colors.blue,
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  onPress: () {
                    if (widget.token?.isNotEmpty == true || widget.token != null) {
                      var body = {"password": _newPass.text.trim()};
                      changePassword(body);
                    } else {
                      var body = {"oldPassword": _oldPass.text.trim(), "newPassword": _newPass.text.trim()};
                      changePassword(body);
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

  Future<void> changePassword(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<ChangePasswordBloc>(context).add(PerformChangePasswordEvent(data: data, id: widget.token));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
