import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/DrawerScreen/Bloc/edit_profile_bloc.dart';
import 'package:award_maker/Screens/MissionScreen/mission_screen.dart';
import 'package:award_maker/Screens/Notification/notification.dart';
import 'package:award_maker/Screens/Settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  late SharedPreferences prefs;
  String? uid;
  String? uname;
  @override
  void initState() {
    super.initState();
    _initData();
    _nameController.text = uname ?? 'N/A';
  }

  Future<void> _initData() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    uname = prefs.getString('uname');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        backgroundColor: const Color(0xFF0B60B0),
        child: BlocConsumer<EditProfileBloc, EditProfileState>(
          listener: (context, editProfileState) {
            if (editProfileState.isCompleted) {
              AlertUtils.showToast('Profile Updated!', context, AnimatedSnackBarType.success);
            } else {
              AlertUtils.showToast(editProfileState.responseMsg ?? '', context, AnimatedSnackBarType.error);
            }
          },
          builder: (context, editProfileState) {
            return Column(
              children: [
                SizedBox(height: 50.h),
                Container(
                  width: double.infinity,
                  color: const Color(0xFF0B60B0),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange,
                        child: Text('SR', style: TextStyle(fontSize: 24, color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child:
                                isEditing
                                    ? TextField(
                                      controller: _nameController,
                                      style: const TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: const BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          uname = value.trim();
                                          isEditing = false;
                                        });
                                      },
                                    )
                                    : Text(uname ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                          IconButton(
                            icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white, size: 24.sp),
                            onPressed: () async {
                              setState(() {
                                if (isEditing) {
                                  uname = _nameController.text.trim();

                                  var body = {"name": uname};
                                  editProfile(uid, body);
                                }
                                isEditing = !isEditing;
                              });
                              await prefs?.setString('uname', _nameController.text.trim());
                              uname = await prefs?.getString('uname');

                              logger.w(uname);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('sreekantha414@gmail.com', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      children: [
                        DrawerTile(
                          icon: Icons.home,
                          title: 'Home',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        DrawerTile(
                          icon: Icons.notifications,
                          title: 'Notification',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                          },
                        ),
                        DrawerTile(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                          },
                        ),
                        DrawerTile(
                          icon: Icons.apartment,
                          title: 'Our Company',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
                          },
                        ),
                        DrawerTile(
                          icon: Icons.star,
                          title: 'Mission Statement',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MissionScreen()));
                          },
                        ),
                        DrawerTile(
                          icon: Icons.privacy_tip,
                          title: 'Privacy Policy',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Fix close button background color
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const CircleAvatar(radius: 22, backgroundColor: Colors.white, child: Icon(Icons.close, color: Colors.red)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> editProfile(String? id, dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<EditProfileBloc>(context).add(PerformEditProfileEvent(id, data));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;
  DrawerTile({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon, color: Colors.black), title: Text(title), onTap: onTap);
  }
}
