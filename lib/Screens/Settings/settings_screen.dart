import 'package:award_maker/Screens/Change%20Password/chnage_password.dart';
import 'package:award_maker/Screens/Notification/Bloc/notification_list_bloc.dart';
import 'package:award_maker/Screens/Settings/Bloc/notification_toggle_bloc.dart';
import 'package:award_maker/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/alert_utils.dart';
import '../../utils/app_helper.dart';
import '../../utils/app_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? isNotificationOn;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    inItData();
  }

  void inItData() async {
    prefs = await SharedPreferences.getInstance();

    setState(() async {
      isNotificationOn = await prefs.getBool('isNotiOn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAF6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins_Bold", fontSize: 18),
        ),
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.black), onPressed: () {}),
      ),
      body: BlocConsumer<NotificationToggleBloc, NotificationToggleState>(
        listener: (context, notificationToggleState) async {
          if (notificationToggleState.isCompleted) {
            await prefs.setBool('isNotiOn', notificationToggleState.model?.result?.notificationEnabled ?? false);
            setState(() async {
              isNotificationOn = await prefs.getBool('isNotiOn');
            });
          }
        },
        builder: (context, notificationToggleState) {
          return Column(
            children: [
              const SizedBox(height: 12),
              _buildCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Switch(
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
                  AppHelper.showLogoutConfirmationDialog(context);
                },
              ),
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
}
