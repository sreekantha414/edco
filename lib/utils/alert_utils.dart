import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'app_Strings.dart';

class AlertUtils {
  static void showAlertDialog(BuildContext context, String title, String message) {
    debugPrint("Display alert");
    showDialog(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Padding(padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0), child: Text(message)),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  static void showAutoCloseDialogue(BuildContext context, String message, int duration, String title) {
    showGeneralDialog(
      barrierLabel: "Label1",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(Duration(seconds: duration), () {
          Navigator.pop(context);
        });
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 20.0.h,
            child: SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2.5.h), topRight: Radius.circular(2.5.h)),
                child: Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.0.h),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            message,
                            style: const TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1), child: child);
      },
    ).then((value) => {debugPrint('Dialogue dismissed')});
  }

  static void showNotInternetDialogue(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Label1",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 90.h,
            child: SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2.5.h), topRight: Radius.circular(2.5.h)),
                child: Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.0.h),
                      const Padding(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          'No Internet!',
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Please check your internet connectivity',
                            style: TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1), child: child);
      },
    ).then((value) => {debugPrint('Dialogue dismissed')});
  }

  static void showToast(String msg, BuildContext? context, AnimatedSnackBarType? snackType) {
    if (AnimatedSnackBarType.success == snackType) {
      showSnackbarSuccess(context, msg);
    } else if (AnimatedSnackBarType.error == snackType) {
      showSnackbarError(context, msg);
    } else {
      showSnackbarWarning(context, msg);
    }
  }

  static void showSnackbarSuccess(BuildContext? context, String message) {
    ScaffoldMessenger.of(context!).showSnackBar(
      AlertUtils._snackbarContent(
        context: context,
        backgroundColor: const Color.fromARGB(255, 27, 148, 92),
        message: message,
        icon: Icons.check_circle,
      ),
    );
  }

  static void showSnackbarError(BuildContext? context, String? message) {
    ScaffoldMessenger.of(context!).showSnackBar(
      _snackbarContent(
        context: context,
        backgroundColor: Colors.red,
        message: message ?? AppConstsStrings.somethingWentWrong,
        icon: Icons.error,
      ),
    );
  }

  static void showSnackbarWarning(BuildContext? context, String message) {
    ScaffoldMessenger.of(context!).showSnackBar(
      _snackbarContent(
        context: context,
        backgroundColor: Colors.amber.shade800, // Yellow color for warning
        message: message,
        icon: Icons.warning, // Warning icon
      ),
    );
  }

  static SnackBar _snackbarContent({
    required BuildContext context,
    required Color backgroundColor,
    required String message,
    required IconData icon,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      margin: EdgeInsets.only(bottom: 60.h, left: 20.w, right: 20.w),
      content: Row(
        children: [
          Expanded(
            flex: 10,
            child: Text(message, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 12, color: Colors.white)),
          ),
          Expanded(child: Icon(icon, color: Colors.white)),
        ],
      ),
    );
  }
}
