import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/Change%20Password/chnage_password.dart';
import 'package:award_maker/Screens/DrawerScreen/drawer_screen.dart';
import 'package:award_maker/Screens/MissionScreen/mission_screen.dart';
import 'package:award_maker/Screens/Notification/Bloc/notification_list_bloc.dart';
import 'package:award_maker/Screens/Settings/Bloc/notification_toggle_bloc.dart';
import 'package:award_maker/api_client/api_constans.dart';
import 'package:award_maker/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/webview_widget.dart';
import '../../api_client/dio_client.dart';
import '../../constants/app_constants.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_helper.dart';
import '../../utils/app_utils.dart';
import '../WelcomeScreen/welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? isNotificationOn;
  bool isLoading = false;
  bool isNotiLoading = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    inItData();
  }

  void inItData() async {
    prefs = await SharedPreferences.getInstance();
    isNotificationOn = await prefs.getBool('isNotiOn');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      backgroundColor: const Color(0xFFFCFAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAF6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins_Bold", fontSize: 18),
        ),
      ),
      body: BlocConsumer<NotificationToggleBloc, NotificationToggleState>(
        listener: (context, notificationToggleState) async {
          if (notificationToggleState.isCompleted) {
            await prefs.setBool('isNotiOn', notificationToggleState.model?.result?.notificationEnabled ?? false);
            isNotificationOn = await prefs.getBool('isNotiOn');

            setState(() {});
          }
        },
        builder: (context, notificationToggleState) {
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        notificationToggleState.isLoading
                            ? CircularProgressIndicator(
                                padding: EdgeInsets.all(5.r),
                              )
                            : Switch(
                                activeColor: Colors.green,
                                thumbColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.grey;
                                }),
                                value: isNotificationOn == true,
                                onChanged: (val) async {
                                  var body = {"notificationEnabled": val};
                                  toggleNotification(body);
                                },
                              ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _buildCard(
                    child: const Row(children: [Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))]),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.logout, color: Color(0xFFEB5757)),
                      ],
                    ),
                    onTap: () {
                      AppHelper.showLogoutConfirmationDialog(
                        context: context,
                        onTap: () async {
                          ///Logout

                          logoutApiCall();
                        },
                        title: 'Confirm you want to logout ?',
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Request for delete the account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Icon(Icons.delete_outline, color: Color(0xFFEB5757)),
                      ],
                    ),
                    onTap: () {
                      AppHelper.showLogoutConfirmationDialog(
                        context: context,
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountDelete()))
                              .then((_) => Navigator.pop(context));
                        },
                        title: 'Confirm you want to delete account ?',
                      );
                    },
                  ),
                ],
              ),
              if (isLoading == true)
                Center(
                  child: CircularProgressIndicator(),
                )
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({required Widget child, required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: child,
      ),
    );
  }

  Future<void> toggleNotification(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<NotificationToggleBloc>(context).add(PerformNotificationToggleEvent(data: data));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<bool> logoutApiCall({String? token}) async {
    Navigator.pop(context);
    setState(() {
      isLoading = true;
    });
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.token);
    try {
      final response = await dio.patch(
        '${APIConstants.baseUrl}logout',
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": basicAuthHeader('trophy_usr', 'hjGGHTy}}78'),
            "authtoken": token,
          },
        ),
      );

      if (response.statusCode == 200) {
        AlertUtils.showToast('Logout Successfully' ?? '', context, AnimatedSnackBarType.success);
        final pref = await SharedPreferences.getInstance();
        await pref.clear();
        AppHelper.signOutGoogle();
        await Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
        setState(() {
          isLoading = true;
        });
        print('✅ Logout successful: ${response.data}');
        return true;
      } else {
        print('⚠ Logout failed: ${response.statusCode} - ${response.data}');
        setState(() {
          isLoading = true;
        });
        return false;
      }
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      print('❌ Logout error: $e');
      return false;
    }
  }
}
